/*
 * vicon_listener.cpp
 *
 *  Created on: Feb 6, 2016
 *      Author: Wassim Rafrafi
 */
#include "ros/ros.h"
#include "std_msgs/String.h"
#include <geometry_msgs/Vector3.h>
#include <tf/transform_broadcaster.h>
#include <sstream>

#include <vicon_bridge/Markers.h>
#include <vicon_bridge/Marker.h>

ros::Publisher m_pubPos;

void markersCallback(const vicon_bridge::Markers::ConstPtr& markers_msg)
{
	int num_subject_markers = markers_msg->markers.size();
	for (int MarkerIndex = 0; MarkerIndex < num_subject_markers; ++MarkerIndex){
		geometry_msgs::Vector3 markers_pos;
		markers_pos.x = markers_msg->markers[MarkerIndex].translation.x/1000;
		markers_pos.y = markers_msg->markers[MarkerIndex].translation.y/1000;
		markers_pos.z = markers_msg->markers[MarkerIndex].translation.z/1000;
		m_pubPos.publish(markers_pos);
		static tf::TransformBroadcaster br;
		tf::Transform transform;
		transform.setOrigin( tf::Vector3(markers_pos.x, markers_pos.y, markers_pos.z) );
		tf::Quaternion q;
		q.setRPY(0, 0, 0);
		transform.setRotation(q);
		br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "world", markers_msg->markers[MarkerIndex].marker_name));
	}
}

int main(int argc, char **argv)
{
	ros::init(argc, argv, "vicon_listener");
	ros::NodeHandle n;
	m_pubPos = n.advertise<geometry_msgs::Vector3>("/vicon/pos", 1000);
	ros::Subscriber sub = n.subscribe("/vicon/markers", 1000, markersCallback);
	ros::spin();

	return 0;
}
