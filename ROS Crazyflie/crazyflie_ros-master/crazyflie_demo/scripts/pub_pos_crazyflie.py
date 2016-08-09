#!/usr/bin/env python
import rospy
from tf.broadcaster import TransformBroadcaster
import tf
from std_msgs.msg import String
import ast
 


br = tf.TransformBroadcaster()


def pos_callback(data):
    s_line = data.data.split( )
    ast.literal_eval(s_line[0])
    x = ast.literal_eval(s_line[0])
    y = ast.literal_eval(s_line[1])
    z = ast.literal_eval(s_line[2]) - 0.5
    
    br.sendTransform((x,y,z),
                     (0.0, 0.0, 0.0, 1.0),
                     rospy.Time.now(),
                     "base_link",
                     "world")
    
    #print "Pos(x,y): %f %f %f" %(x,y,z )
    
         
def algo_imu_uwb():
    rospy.init_node('pub_pos_crazyflie', anonymous=True)
    rospy.Subscriber("/vicon/pos", String, pos_callback)
    rospy.spin()

if __name__ == '__main__':
    try:
        algo_imu_uwb()
    except rospy.ROSInterruptException:
        pass
