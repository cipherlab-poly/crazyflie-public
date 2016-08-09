#include <math.h>
#include "stabilizer.h"
#include "stabilizer_types.h"

#include "attitude_controller.h"
#include "sensfusion6.h"
#include "position_controller.h"

#include "log.h"

#define ATTITUDE_RATE RATE_500_HZ
#define POSITION_RATE RATE_100_HZ
#define K_theta 8203.2 //8165.7 // 7251.5 //9911.3 //8962.4  //7018.733
#define K_psi 8561 //8511.4 //7596.5
#define K_pq 998.4 //996.7 //954 //1073.5 //1032.5 //2005.35
#define K_r 1344.6 //1341.3 //1277.7 //1420
#define Ki 8660.3 //8366.6 //7905.7 //5000 //4010.7046
#define pi 3.141592654
#define integ_max 0.35

static struct {
  float phi;;
  float theta;
  float psi;
} integ;

static attitude_t attitudeDesired;
static attitude_t rateDesired;
static float actuatorThrust;

void stateControllerInit(void)
{
  attitudeControllerInit();
}

bool stateControllerTest(void)
{
  bool pass = true;

  pass &= attitudeControllerTest();

  return pass;
}

void stateController(control_t *control, const sensorData_t *sensors,
                                         const state_t *state,
                                         const setpoint_t *setpoint,
                                         const uint32_t tick)
{ float phi,theta,psi;
  float e_phi,e_theta,e_psi;
  float p,q,r;

  if (RATE_DO_EXECUTE(ATTITUDE_RATE, tick)) {
	//Retrieve data from sensor fusion algorithm
	phi = state->attitude.roll*pi/180;
	theta = -state->attitude.pitch*pi/180;
	psi = state->attitude.yaw*pi/180;

	//Error calculation given a setpoint from the client -- Only uncomment if you want to use the client
//	e_phi = setpoint->attitude.roll*pi/180-phi;
//	e_theta = -setpoint->attitude.pitch*pi/180-theta;
//	e_psi = setpoint->attitudeRate.yaw*pi/180-psi;

	//Error calculation for full-state feedback LQT
	e_phi = -phi;
	e_theta = -theta;
	e_psi = -psi;

	//Calculate integral of error
	integ.phi+=(e_phi)/500;
	integ.theta+=(e_theta)/500;
	integ.psi+=(e_psi)/500;

	//Limit integral outputs
	if(integ.phi>integ_max){
		integ.phi=integ_max;
	}
	else if (integ.phi<-integ_max){
		integ.phi=-integ_max;
	}

	if(integ.theta>integ_max){
		integ.theta=integ_max;
	}
	else if (integ.theta<-integ_max){
		integ.theta=-integ_max;
	}

	if(integ.psi>integ_max){
		integ.psi=integ_max;
	}
	else if (integ.psi<-integ_max){
		integ.psi=-integ_max;
	}

	//Estimation of angular velocities in the body frame
	p = sensors->gyro.x*pi/180-sin(theta)*sensors->gyro.z*pi/180;
	q = cos(phi)*sensors->gyro.y*pi/180+sin(phi)*cos(theta)*sensors->gyro.z*pi/180;
	r = -sin(phi)*sensors->gyro.y*pi/180+cos(phi)*cos(theta)*sensors->gyro.z*pi/180;

	//Control law with LQR gains
	control->roll = -K_psi*(e_psi) + K_theta*(-e_theta-e_phi) -K_r*(-r) - K_pq*(-p-q) - Ki*(integ.theta+integ.phi+integ.psi); //M1
	control->pitch = K_psi*(e_psi) + K_theta*(e_theta-e_phi)  -K_r*(r)  - K_pq*(-p+q) + Ki*(integ.theta-integ.phi+integ.psi);//M2
	control->yaw =  -K_psi*(e_psi) + K_theta*(e_theta+e_phi)  -K_r*(-r) - K_pq*(p+q)  + Ki*(integ.theta+integ.phi-integ.psi); //M3
	control->thrust= K_psi*(e_psi) + K_theta*(-e_theta+e_phi) -K_r*(r)  - K_pq*(p-q)  - Ki*(integ.theta-integ.phi-integ.psi); //M2
	//End of new implementation
  }
}


LOG_GROUP_START(controller)
LOG_ADD(LOG_FLOAT, actuatorThrust, &actuatorThrust)
LOG_GROUP_STOP(controller)

LOG_GROUP_START(integrator)
LOG_ADD(LOG_FLOAT, integ_theta, &integ.theta)
LOG_GROUP_STOP(integrator)
