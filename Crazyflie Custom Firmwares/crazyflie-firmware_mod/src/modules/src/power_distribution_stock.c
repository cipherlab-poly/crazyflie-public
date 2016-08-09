/**
 *    ||          ____  _ __
 * +------+      / __ )(_) /_______________ _____  ___
 * | 0xBC |     / __  / / __/ ___/ ___/ __ `/_  / / _ \
 * +------+    / /_/ / / /_/ /__/ /  / /_/ / / /_/  __/
 *  ||  ||    /_____/_/\__/\___/_/   \__,_/ /___/\___/
 *
 * Crazyflie control firmware
 *
 * Copyright (C) 2011-2016 Bitcraze AB
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, in version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * power_distribution_stock.c - Crazyflie stock power distribution code
 */
#include "power_distribution.h"

#include "log.h"
#include "num.h"

#include "motors.h"

static struct {
  uint32_t m1;
  uint32_t m2;
  uint32_t m3;
  uint32_t m4;
} motorPower;

void powerDistributionInit(void)
{
  motorsInit(motorMapDefaultBrushed);
}

bool powerDistributionTest(void)
{
  bool pass = true;

  pass &= motorsTest();

  return pass;
}

#define limitThrust(VAL) limitUint16(VAL)

void powerDistribution(const control_t *control, const setpoint_t *setpoint)
{
//  #ifdef QUAD_FORMATION_X -- To be used with the CFCLIENT
//    motorPower.m1 = limitThrust(control->roll+setpoint->thrust);
//    motorPower.m2 = limitThrust(control->pitch+setpoint->thrust);
//    motorPower.m3 =  limitThrust(control->yaw+setpoint->thrust);
//    motorPower.m4 =  limitThrust(control->thrust+setpoint->thrust);

  #ifdef QUAD_FORMATION_X
    motorPower.m1 = limitThrust(control->roll+setpoint->attitude.roll);
    motorPower.m2 = limitThrust(control->pitch+setpoint->attitude.pitch);
    motorPower.m3 =  limitThrust(control->yaw+setpoint->attitudeRate.yaw);
    motorPower.m4 =  limitThrust(control->thrust+setpoint->thrust);
  #else // QUAD_FORMATION_NORMAL
    motorPower.m1 = limitThrust(setpoint->attitude.roll);
    motorPower.m2 = limitThrust(setpoint->attitude.pitch);
    motorPower.m3 =  limitThrust(setpoint->attitudeRate.yaw);
    motorPower.m4 =  limitThrust(setpoint->thrust);
  #endif
  if(setpoint->thrust>5000){
	  motorsSetRatio(MOTOR_M1, motorPower.m1);
	  motorsSetRatio(MOTOR_M2, motorPower.m2);
	  motorsSetRatio(MOTOR_M3, motorPower.m3);
	  motorsSetRatio(MOTOR_M4, motorPower.m4);
  }
  else{
	  motorsSetRatio(MOTOR_M1, 0);
	  motorsSetRatio(MOTOR_M2, 0);
	  motorsSetRatio(MOTOR_M3, 0);
	  motorsSetRatio(MOTOR_M4, 0);
  }
}

LOG_GROUP_START(motor)
LOG_ADD(LOG_INT32, m4, &motorPower.m4)
LOG_ADD(LOG_INT32, m1, &motorPower.m1)
LOG_ADD(LOG_INT32, m2, &motorPower.m2)
LOG_ADD(LOG_INT32, m3, &motorPower.m3)
LOG_GROUP_STOP(motor)
