# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "crazyflie_driver: 0 messages, 2 services")

set(MSG_I_FLAGS "-Istd_msgs:/opt/ros/indigo/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(crazyflie_driver_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/AddCrazyflie.srv" NAME_WE)
add_custom_target(_crazyflie_driver_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "crazyflie_driver" "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/AddCrazyflie.srv" ""
)

get_filename_component(_filename "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/UpdateParams.srv" NAME_WE)
add_custom_target(_crazyflie_driver_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "crazyflie_driver" "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/UpdateParams.srv" ""
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services
_generate_srv_cpp(crazyflie_driver
  "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/AddCrazyflie.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/crazyflie_driver
)
_generate_srv_cpp(crazyflie_driver
  "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/UpdateParams.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/crazyflie_driver
)

### Generating Module File
_generate_module_cpp(crazyflie_driver
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/crazyflie_driver
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(crazyflie_driver_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(crazyflie_driver_generate_messages crazyflie_driver_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/AddCrazyflie.srv" NAME_WE)
add_dependencies(crazyflie_driver_generate_messages_cpp _crazyflie_driver_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/UpdateParams.srv" NAME_WE)
add_dependencies(crazyflie_driver_generate_messages_cpp _crazyflie_driver_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(crazyflie_driver_gencpp)
add_dependencies(crazyflie_driver_gencpp crazyflie_driver_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS crazyflie_driver_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages

### Generating Services
_generate_srv_lisp(crazyflie_driver
  "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/AddCrazyflie.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/crazyflie_driver
)
_generate_srv_lisp(crazyflie_driver
  "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/UpdateParams.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/crazyflie_driver
)

### Generating Module File
_generate_module_lisp(crazyflie_driver
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/crazyflie_driver
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(crazyflie_driver_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(crazyflie_driver_generate_messages crazyflie_driver_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/AddCrazyflie.srv" NAME_WE)
add_dependencies(crazyflie_driver_generate_messages_lisp _crazyflie_driver_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/UpdateParams.srv" NAME_WE)
add_dependencies(crazyflie_driver_generate_messages_lisp _crazyflie_driver_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(crazyflie_driver_genlisp)
add_dependencies(crazyflie_driver_genlisp crazyflie_driver_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS crazyflie_driver_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages

### Generating Services
_generate_srv_py(crazyflie_driver
  "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/AddCrazyflie.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/crazyflie_driver
)
_generate_srv_py(crazyflie_driver
  "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/UpdateParams.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/crazyflie_driver
)

### Generating Module File
_generate_module_py(crazyflie_driver
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/crazyflie_driver
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(crazyflie_driver_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(crazyflie_driver_generate_messages crazyflie_driver_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/AddCrazyflie.srv" NAME_WE)
add_dependencies(crazyflie_driver_generate_messages_py _crazyflie_driver_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/carlosluis/catkin_ws/src/crazyflie_ros/crazyflie_driver/srv/UpdateParams.srv" NAME_WE)
add_dependencies(crazyflie_driver_generate_messages_py _crazyflie_driver_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(crazyflie_driver_genpy)
add_dependencies(crazyflie_driver_genpy crazyflie_driver_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS crazyflie_driver_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/crazyflie_driver)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/crazyflie_driver
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(crazyflie_driver_generate_messages_cpp std_msgs_generate_messages_cpp)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/crazyflie_driver)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/crazyflie_driver
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(crazyflie_driver_generate_messages_lisp std_msgs_generate_messages_lisp)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/crazyflie_driver)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/crazyflie_driver\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/crazyflie_driver
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
add_dependencies(crazyflie_driver_generate_messages_py std_msgs_generate_messages_py)
