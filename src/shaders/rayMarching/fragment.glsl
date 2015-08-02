uniform float time;
uniform sampler2D tDiffuse;

varying vec2 vUv;

float sphere(vec3 p, vec3 sphere, float radius)
{
  return length(p - sphere) - radius;
}

float distance(vec3 p)
{
  return sphere(p, vec3(.0, .0, .0), 0.5);
}

int castRay(vec3 ro, vec3 rd)
{
  float t = 0.0;
  const int maxSteps = 32;
  for(int i = 0; i < maxSteps; ++i)
  {
    vec3 p = ro + rd * t;
    float d = distance(p);
    if(d < 0.01)
    {
      return i;
    }

    t += d;
  }

  return maxSteps;
}

void main()
{
  vec3 eye = vec3(0, 0, -1);
  vec3 up = vec3(0, 1, 0);
  vec3 right = vec3(1, 0, 0);

  float u = (vUv.x * 2.0) - 1.0;
  float v = (vUv.y * 2.0) - 1.0;

  vec3 rd = normalize(cross(right, up));
  vec3 ro = right * u + up * v;

  int depth = castRay(ro, rd);

  vec4 color = vec4(0.0);
  if (depth < 32) {
      color = vec4(1.0, 0.5, 0.5, 1.0);
  }

  gl_FragColor = color;
}
