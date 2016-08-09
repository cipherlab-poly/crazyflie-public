#include <ros/ros.h>
#include <tf/transform_listener.h>
#include <std_srvs/Empty.h>
#include <geometry_msgs/Twist.h>
#include <geometry_msgs/Vector3.h>
#include <sensor_msgs/Joy.h>
#include <std_msgs/String.h>
#include <sensor_msgs/Imu.h>
#include <iostream>
#include <vector>
#include <string>
#include <sstream>

#include "pid.hpp"

using namespace std;

double get(
		const ros::NodeHandle& n,
		const std::string& name) {
	double value;
	n.getParam(name, value);
	return value;
}

class Controller
{
public:

	Controller(
			const std::string& frame,
			const ros::NodeHandle& n)
: m_frame(frame)
, m_pubNav()
, m_listener()
, m_pidX(
		get(n, "PIDs/X/kp"),
		get(n, "PIDs/X/kd"),
		get(n, "PIDs/X/ki"),
		get(n, "PIDs/X/minOutput"),
		get(n, "PIDs/X/maxOutput"),
		get(n, "PIDs/X/integratorMin"),
		get(n, "PIDs/X/integratorMax"),
		"x")
, m_pidY(
		get(n, "PIDs/Y/kp"),
		get(n, "PIDs/Y/kd"),
		get(n, "PIDs/Y/ki"),
		get(n, "PIDs/Y/minOutput"),
		get(n, "PIDs/Y/maxOutput"),
		get(n, "PIDs/Y/integratorMin"),
		get(n, "PIDs/Y/integratorMax"),
		"y")
, m_pidZ(
		get(n, "PIDs/Z/kp"),
		get(n, "PIDs/Z/kd"),
		get(n, "PIDs/Z/ki"),
		get(n, "PIDs/Z/minOutput"),
		get(n, "PIDs/Z/maxOutput"),
		get(n, "PIDs/Z/integratorMin"),
		get(n, "PIDs/Z/integratorMax"),
		"z")
, m_pidYaw(
		get(n, "PIDs/Yaw/kp"),
		get(n, "PIDs/Yaw/kd"),
		get(n, "PIDs/Yaw/ki"),
		get(n, "PIDs/Yaw/minOutput"),
		get(n, "PIDs/Yaw/maxOutput"),
		get(n, "PIDs/Yaw/integratorMin"),
		get(n, "PIDs/Yaw/integratorMax"),
		"yaw")

, m_thrust(0)
, actual_x(0)
, actual_y(0)
, actual_z(0)
, goal_x(0)
, goal_y(0)
, goal_z(0)
, goal_select(0)
, yaw_mode(0)
, goal_yaw(0)
, old_x(0)
, old_y(0)
, actual_roll(0)
, actual_pitch(0)
, actual_yaw(0)
, last_m_state(0)
, d_x(0)
, d_y(0)
, i(0)
, land_req(0)
, num(0)
{
		ros::NodeHandle nh;
		m_pubNav = nh.advertise<geometry_msgs::Twist>("cmd_vel", 100);
		m_joy_sub = nh.subscribe<sensor_msgs::Joy>("joy", 10, &Controller::joyCallback, this);
		m_imu_sub = nh.subscribe("/crazyflie/imu", 1000, &Controller::imuCallback, this);
		m_viconpos_sub = nh.subscribe("/vicon/pos", 1000, &Controller::posViconCallback, this);
		m_goal_sub = nh.subscribe("/goal", 1000, &Controller::GoalCallback, this);
}

	void run(double frequency)
	{
		ros::NodeHandle node;
		ros::Timer timer = node.createTimer(ros::Duration(1.0/frequency), &Controller::iteration, this);
		ros::spin();
	}

private:
	void joyCallback(const sensor_msgs::Joy::ConstPtr& joy)
	{  //Routine to manage PS4 buttons as inputs
		int i;
		int j;

		if(num==0){
			for(i=0;i<14;i++)
				m_hover[i]=0;
		}

		if (remainder(2*num+1,2)==1){
			for(i=0;i<14;i++){
				last_hover_state[i]=m_hover[i];
				m_hover[i]=joy->buttons[i];
				std::cout << m_hover[i] << " " << last_hover_state[i]<< std::endl;
				}
			std::cout << " joy callback " << std::endl;
			last_m_state = m_state;
			for(i=0;i<14;i++){
				if (last_hover_state[i]!=m_hover[i]){
					m_state=i;
					if (last_m_state>m_state)
						i=15;
				}
			}
		}
		num++;
	}

	void posViconCallback( const geometry_msgs::Vector3::ConstPtr& msg)
	{

		actual_x = msg->x;
		actual_y = msg->y;
		actual_z = msg->z;

	}

	void GoalCallback( const geometry_msgs::Twist::ConstPtr& msg)
	{

		goal_x = msg->linear.x+x_0;    //X Setpoint
		goal_y = msg->linear.y+y_0;    //Y Setpoint
		goal_z = msg->linear.z;        //Z Setpoint
		goal_select = msg->angular.x;  //Trajectory Selector
		yaw_mode = msg->angular.y;     //Select Yaw mode: angular or rate
		goal_yaw = msg->angular.z;     //Yaw Setpoint

	}

	void imuCallback(const sensor_msgs::Imu::ConstPtr& msg)
	{
		actual_roll = msg->angular_velocity.x*3.141592654/180;
		actual_pitch = msg->angular_velocity.y*3.141592654/180;
		actual_yaw = msg->angular_velocity.z*3.141592654/180;
	}


	void pidReset()
	{
			m_pidX.reset();
			m_pidZ.reset();
			m_pidZ.reset();
			m_pidYaw.reset();
	}

	void iteration(const ros::TimerEvent& e)
	{
		float dt = e.current_real.toSec() - e.last_real.toSec();
		float pi = 3.141592654;


		switch(goal_select) //Selected via MATLAB interface
		{
		case 0:  //Mode Idle, do nothing and await new commands
		{	ROS_INFO("MODE IDLE");
			geometry_msgs::Twist msg;
			if(i==0 && actual_x!=0){ //Save initial coordinates as point (0,0)
				x_0=actual_x;
				y_0=actual_y;
				i++;
			}

			pidReset();
			msg.linear.x =0;
			msg.linear.y =0;
			msg.linear.z=0;
			msg.angular.z = 0;
		m_pubNav.publish(msg);
		}
		break;


		case 1: //Landing on demand
		{
			ROS_INFO("Landing");
			geometry_msgs::Twist msg;
			if(land_req==0 && actual_x!=0){ //Take current coordinates as landing site
				x_0=actual_x;
				y_0=actual_y;
				z_0=actual_z;
				land_req++;
			}
			m_thrust =45000 + m_pidZ.update(actual_z , z_0+goal_z);
			if(actual_z>0.25){
				d_x = (cos(actual_yaw) * (actual_x-old_x) + sin(actual_yaw) * (actual_y-old_y))/0.01;
				d_y = (-sin(actual_yaw) * (actual_x-old_x) + cos(actual_yaw) * (actual_y-old_y))/0.01;
				old_x = actual_x;
				old_y = actual_y;
				//First we take the difference between the last value of X-Y and the present value
				//Then we do the appropriate rotation if we have some yaw angle to align the axis
				xy_error[0] =  cos(actual_yaw) * (x_0 - actual_x) + sin(actual_yaw) * (y_0 - actual_y);
				xy_error[1] = -sin(actual_yaw) * (x_0 - actual_x) + cos(actual_yaw) * (y_0 - actual_y);
				msg.linear.x =m_pidX.update(d_x, xy_error[0]);
				msg.linear.y =m_pidY.update(d_y, xy_error[1]);
				msg.linear.z=m_thrust;
				msg.angular.z = m_pidYaw.update(actual_yaw*180/pi,0);
			}

			else {
				msg.linear.x =0;
				msg.linear.y =0;
				msg.linear.z=0;
				msg.angular.z = 0;
			}
			if (m_state==1){
			ROS_INFO("Emergency Stop");
			msg.linear.x = 0;
			msg.linear.y = 0;
			msg.linear.z = 0;
			msg.angular.z = 0;
		}
		m_pubNav.publish(msg);
		}
		break;


		default: //Default for any trajectory other than take-off and landing
		{
			ROS_INFO("Following a Trajectory");
			geometry_msgs::Twist msg;
			m_thrust =45000 + m_pidZ.update(actual_z , goal_z);
			if(actual_z>0.25){  //After take-off
				d_x = (cos(actual_yaw) * (actual_x-old_x) + sin(actual_yaw) * (actual_y-old_y))/0.01;
				d_y = (-sin(actual_yaw) * (actual_x-old_x) + cos(actual_yaw) * (actual_y-old_y))/0.01;
				old_x = actual_x;
				old_y = actual_y;
				//First we take the difference between the last value of X-Y and the present value
				//Then we do the appropriate rotation if we have some yaw angle to align the axis
				xy_error[0] =  cos(actual_yaw) * (goal_x - actual_x) + sin(actual_yaw) * (goal_y - actual_y);
				xy_error[1] = -sin(actual_yaw) * (goal_x - actual_x) + cos(actual_yaw) * (goal_y - actual_y);
				//This PID takes like input the difference between the error in x-y
				//and maps it to a desired velocity, which is compared with the actual linear velocity
				msg.linear.x =m_pidX.update(d_x, xy_error[0]);
				msg.linear.y =m_pidY.update(d_y, xy_error[1]);
				msg.linear.z=m_thrust;
				if(yaw_mode==0) //Yaw angular mode
					msg.angular.z = m_pidYaw.update(actual_yaw*180/pi,goal_yaw);
				else  //Yaw rate mode
					msg.angular.z=goal_yaw;

			}
			else{  //Before Take-off
				msg.linear.z=45000;
				msg.linear.x = 0;
				msg.linear.y = 0;
				msg.angular.z = 0;
			}
			if (m_state==1){
			ROS_INFO("Emergency Stop");
			msg.linear.x = 0;
			msg.linear.y = 0;
			msg.linear.z = 0;
			msg.angular.z = 0;
		}
		m_pubNav.publish(msg);
		}
		break;

		}

	}


public:
	static float x_0,y_0,z_0;
private:
	std::string m_frame;
	ros::Publisher m_pubNav;
	tf::TransformListener m_listener;
	PID m_pidX;
	PID m_pidY;
	PID m_pidZ;
	PID m_pidYaw;
	ros::Subscriber m_joy_sub;
	ros::Subscriber m_imu_sub;
	ros::Subscriber m_viconpos_sub;
	ros::Subscriber m_goal_sub;

	//Variables for PS4 controller management
	int m_hover[14];
	int last_hover_state[14];
	int m_state;
	int last_m_state;
	double num;

	//Variables from MATLAB node

	float goal_x;
	float goal_y;
	float goal_z;
	int goal_select;
	int yaw_mode;
	float goal_yaw;

	//Variables of the control process

	float m_thrust;
	float actual_x;
	float old_x;
	float actual_y;
	float xy_error[2];
	float old_y;
	float actual_z;
	float actual_roll;
	float actual_pitch;
	float actual_yaw;
	float d_x,d_y;
	int i;
	int land_req;

};

float Controller::x_0 = 0.0;
float Controller::y_0 = 0.0;
float Controller::z_0 = 0.0;

int main(int argc, char **argv)
{

	ros::init(argc, argv, "controller");

	ros::NodeHandle n("~");
	std::string frame;
	n.getParam("frame", frame);

	Controller controller(frame, n);

	double frequency;
	n.param("frequency", frequency, 100.0);
	controller.run(frequency);

	return 0;
}
