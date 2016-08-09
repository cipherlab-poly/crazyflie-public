#!/usr/bin/env python
import rospy
from std_msgs.msg import String

def run():
    pub = rospy.Publisher('/crazyflie/goal', String, queue_size=10)
    rospy.init_node('pub_trajectory', anonymous=True)
    rate = rospy.Rate(50) # 10hz
    while not rospy.is_shutdown():
        hello_str = "hello world %s" % rospy.get_time()
        rospy.loginfo(hello_str)
        pub.publish(hello_str)
        rate.sleep()

if __name__ == '__main__':
    try:
        run()
    except rospy.ROSInterruptException:
        pass