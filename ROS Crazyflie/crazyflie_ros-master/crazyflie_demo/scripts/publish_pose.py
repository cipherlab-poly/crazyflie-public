#!/usr/bin/env python

import rospy
import tf
from geometry_msgs.msg import PoseStamped
import numpy as np
import math

if __name__ == '__main__':
    rospy.init_node('publish_pose', anonymous=True)
    name = rospy.get_param("~name")
    r = rospy.get_param("~rate")
    x = rospy.get_param("~x")
    y = rospy.get_param("~y")
    z = rospy.get_param("~z")

    rate = rospy.Rate(r)
    
    rate_angle = 100
    angle = np.linspace(-math.pi,math.pi,rate_angle)
    radius = 0.25
    x0 = x
    y0 = y
    i = 0

    msg = PoseStamped()
    msg.header.seq = 0
    msg.header.stamp = rospy.Time.now()
    msg.header.frame_id = "world"
    msg.pose.position.x = x
    msg.pose.position.y = y
    msg.pose.position.z = z
    quaternion = tf.transformations.quaternion_from_euler(0, 0, 0)
    msg.pose.orientation.x = quaternion[0]
    msg.pose.orientation.y = quaternion[1]
    msg.pose.orientation.z = quaternion[2]
    msg.pose.orientation.w = quaternion[3]

    pub = rospy.Publisher(name, PoseStamped, queue_size=1)

    while not rospy.is_shutdown():
        msg.header.seq += 1
        msg.header.stamp = rospy.Time.now()
        #msg.pose.position.x = radius * math.cos(angle[i]) + x0
        #msg.pose.position.y = radius * math.sin(angle[i]) + y0
        #i = i + 1
        #if i>rate_angle-1:
        #    i = 0
        pub.publish(msg)
        rate.sleep()
