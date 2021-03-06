#!/bin/bash

function error {
    exit 1
}
trap error ERR

OUTPUT_FILE=$1
# continuous joint not working in GAZEBO
sed -i -e 's@continuous@revolute@g' ${OUTPUT_FILE}
# overwrite mass and inertia which have invalid settings.
sed -i -e 's@<mass value="0" />@<mass value="1e-03" />@g' ${OUTPUT_FILE}
sed -i -e 's@<inertia ixx="0" ixy="0" ixz="0" iyy="0" iyz="0" izz="0"/>@<inertia ixx="1e-04" ixy="0" ixz="0" iyy="1e-04" iyz="0" izz="1e-04"/>@g' ${OUTPUT_FILE}
## change foot parameters
sed -i -e '/<gazebo reference="LLEG_LINK5">/{N;N;N;N;s@  <gazebo reference="LLEG_LINK5">\n    <mu1>0.9</mu1>\n    <mu2>0.9</mu2>\n  </gazebo>@  <gazebo reference="LLEG_LINK5">\n    <kp>1400000.0</kp>\n    <kd>280.0</kd>\n    <mu1>1.5</mu1>\n    <mu2>1.5</mu2>\n    <fdir1>1 0 0</fdir1>\n    <maxVel>10.0</maxVel>\n    <minDepth>0.00</minDepth>\n  </gazebo>@;}' ${OUTPUT_FILE}
sed -i -e '/<gazebo reference="RLEG_LINK5">/{N;N;N;N;s@  <gazebo reference="RLEG_LINK5">\n    <mu1>0.9</mu1>\n    <mu2>0.9</mu2>\n  </gazebo>@  <gazebo reference="RLEG_LINK5">\n    <kp>1400000.0</kp>\n    <kd>280.0</kd>\n    <mu1>1.5</mu1>\n    <mu2>1.5</mu2>\n    <fdir1>1 0 0</fdir1>\n    <maxVel>10.0</maxVel>\n    <minDepth>0.00</minDepth>\n  </gazebo>@;}' ${OUTPUT_FILE}
sed -i -e '/<gazebo reference="LLEG_LINK6">/{N;N;N;N;s@  <gazebo reference="LLEG_LINK6">\n    <mu1>0.9</mu1>\n    <mu2>0.9</mu2>\n  </gazebo>@  <gazebo reference="LLEG_LINK6">\n    <kp>1400000.0</kp>\n    <kd>280.0</kd>\n    <mu1>1.5</mu1>\n    <mu2>1.5</mu2>\n    <fdir1>1 0 0</fdir1>\n    <maxVel>10.0</maxVel>\n    <minDepth>0.00</minDepth>\n  </gazebo>@;}' ${OUTPUT_FILE}
sed -i -e '/<gazebo reference="RLEG_LINK6">/{N;N;N;N;s@  <gazebo reference="RLEG_LINK6">\n    <mu1>0.9</mu1>\n    <mu2>0.9</mu2>\n  </gazebo>@  <gazebo reference="RLEG_LINK6">\n    <kp>1400000.0</kp>\n    <kd>280.0</kd>\n    <mu1>1.5</mu1>\n    <mu2>1.5</mu2>\n    <fdir1>1 0 0</fdir1>\n    <maxVel>10.0</maxVel>\n    <minDepth>0.00</minDepth>\n  </gazebo>@;}' ${OUTPUT_FILE}
# remove LARM_LINK6
L_START=`grep -n "<link name=\"LARM_LINK6\"" -m 1 ${OUTPUT_FILE} -m 1 | cut -f1 -d:`
L_END=$(sed -n "${L_START},\$p" ${OUTPUT_FILE} | grep -n "<\/gazebo>" -m 1 | cut -f1 -d:) ##
L_END=`expr ${L_START} + ${L_END} - 1`
sed -i -e "${L_START},${L_END}d" ${OUTPUT_FILE}
# remove RARM_LINK6
L_START=`grep -n "<link name=\"RARM_LINK6\"" ${OUTPUT_FILE} -m 1 | cut -f1 -d:`
L_END=$(sed -n "${L_START},\$p" ${OUTPUT_FILE} | grep -n "<\/gazebo>" -m 1 | cut -f1 -d:) ##
L_END=`expr ${L_START} + ${L_END} - 1`
sed -i -e "${L_START},${L_END}d" ${OUTPUT_FILE}
# overwrite velocity limit because collada2urdf doesn't reflect the velocity limit of collada model.
sed -i -e 's@velocity="0.5"@velocity="1000.0"@g' ${OUTPUT_FILE}
sed -i -e 's@effort="100"@effort="1000"@g' ${OUTPUT_FILE}
