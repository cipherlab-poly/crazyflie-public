#!/usr/bin/env python

import rospy
from sensor_msgs.msg import Joy
from crazyflie_driver.srv import UpdateParams
from std_srvs.srv import Empty

class Controller():
    def __init__(self, use_controller, joy_topic):
        rospy.wait_for_service('update_params')
        rospy.loginfo("found update_params service")
        self._update_params = rospy.ServiceProxy('update_params', UpdateParams)

        rospy.loginfo("waiting for emergency service")
        rospy.wait_for_service('emergency')
        rospy.loginfo("found emergency service")
        self._emergency = rospy.ServiceProxy('emergency', Empty)

        if use_controller:
            rospy.loginfo("waiting for Hover service")
            rospy.wait_for_service('Hover')
            rospy.loginfo("found Hover service")
            self._hover = rospy.ServiceProxy('Hover', Empty)

            rospy.loginfo("waiting for Idel service")
            rospy.wait_for_service('Idel')
            rospy.loginfo("found Idel service")
            self._idle = rospy.ServiceProxy('Idel', Empty)
        else:
            self._hover = None
            self._idle = None

        # subscribe to the joystick at the end to make sure that all required
        # services were found
        self._buttons = None
        rospy.Subscriber(joy_topic, Joy, self._joyChanged)

    def _joyChanged(self, data):
        for i in range(0, len(data.buttons)):
            if self._buttons == None or data.buttons[i] != self._buttons[i]:
                if i == 0 and data.buttons[i] == 1 and self._hover != None:
                    self._hover()
                if i == 1 and data.buttons[i] == 1:
                    self._emergency()
                if i == 2 and data.buttons[i] == 1 and self._idle != None:
                    self._idle()

        self._buttons = data.buttons

if __name__ == '__main__':
    rospy.init_node('crazyflie_demo_controller', anonymous=True)
    use_controller = rospy.get_param("~use_crazyflie_controller", False)
    joy_topic = rospy.get_param("~joy_topic", "joy")
    controller = Controller(use_controller, joy_topic)
    rospy.spin()
