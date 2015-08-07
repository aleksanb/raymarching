uniform float time;
uniform sampler2D tDiffuse;

varying vec2 vUv;

float sphere(vec3 p, vec3 sphere, float radius)
{
  return length(p - sphere) - radius;
}

float distance(vec3 p)
{
  //p.x = mod(p.x, 5.0) - 2.5;

  return sphere(p, vec3(.0, .0, .0), 4.0);
}

float castRay(vec3 ro, vec3 rd)
{
  float closeClippingPlane = 0.0;
  float farClippingPlane = 40.0;

  float totalDistance = closeClippingPlane;
  const int maxSteps = 32;
  for(int i = 0; i < maxSteps; ++i)
  {
    vec3 p = ro + rd * totalDistance;
    float d = distance(p);
    if(d < 0.01 || totalDistance > farClippingPlane)
    {
      break;
    }

    totalDistance += d;
  }

  return totalDistance;
}

void main()
{
  vec3 pos = vec3(0, 0, 10);
  vec3 up = vec3(0, 1, 0);
  vec3 right = vec3(1, 0, 0);

  float far = 20.0;
  float u = (vUv.x * 16.0) - 8.0;
  float v = (vUv.y * 9.0) - 4.5;

  vec3 rd = normalize(cross(up, right));
  vec3 ro = pos + (right * u) + (up * v);

  float distance = castRay(ro, rd);
  vec4 color = vec4(1.0);
  if (distance <= 40.0) {
    color = vec4(1.0, 0.5, 0.1, 1.0) * distance / 10.0;
  }

  gl_FragColor = color;
}
