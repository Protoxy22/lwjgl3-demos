/*
 * Copyright LWJGL. All rights reserved.
 * License terms: http://lwjgl.org/license.php
 */
#version 110

uniform mat4 viewProj;
uniform mat4 invViewProj;
uniform vec3 cameraPosition;

uniform vec3 blackholePosition;
uniform float blackholeSize;

varying vec3 dir;

mat4 billboardMatrix() {
  vec3 toDir = cameraPosition - blackholePosition;
  vec3 v = vec3(-toDir.y, toDir.x, length(toDir) + toDir.z);
  v = normalize(v);
  float q00 = 2.0 * v.x * v.x;
  float q11 = 2.0 * v.y * v.y;
  float q01 = 2.0 * v.x * v.y;
  float q03 = 2.0 * v.x * v.z;
  float q13 = 2.0 * v.y * v.z;
  return mat4(vec4(1.0 - q11, q01, -q13, 0.0),
              vec4(q01, 1.0 - q00, q03, 0.0),
              vec4(q13, -q03, 1.0 - q11 - q00, 0.0),
              vec4(blackholePosition, 1.0));
}

void main(void) {
  vec4 scaling = vec4(blackholeSize, blackholeSize, 1.0, 1.0);
  vec4 homClipPos = viewProj * billboardMatrix() * (gl_Vertex * scaling);
  vec4 homWorldPos = invViewProj * homClipPos;
  vec4 worldPos = homWorldPos / homWorldPos.w;
  dir = worldPos.xyz - cameraPosition;
  gl_Position = homClipPos;
}