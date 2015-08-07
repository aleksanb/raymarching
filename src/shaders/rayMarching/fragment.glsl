uniform float time;
uniform sampler2D tDiffuse;

varying vec2 vUv;

float sphere(vec3 position, vec3 sphere, float radius)
{
  return length(position - sphere) - radius;
}

float box(vec3 position, vec3 box, vec3 dimensions)
{
  return length(max(abs(position - box) - dimensions, 0.0));
}

float distance(vec3 p)
{
  //p.x = mod(p.x, 5.0) - 2.5;
  //p.z = mod(p.z, 5.0) - 2.5;

  float s = sphere(p, vec3(.0, .0, .0), 2.0);
  float b = box(p, vec3(3.0, 0.1, -10.0), vec3(2.0));

  return min(s, b);
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

vec3 calculateNormal(vec3 pos) {
  vec3 eps = vec3(0.001, 0.0, 0.0);
  vec3 normal = vec3(
    distance(pos + eps.xyy) - distance(pos - eps.xyy),
    distance(pos + eps.yxy) - distance(pos - eps.yxy),
    distance(pos + eps.yyx) - distance(pos - eps.yyx));

  return normalize(normal);
}

void main()
{
  vec3 eye = vec3(0, 0, 10);
  vec3 up = vec3(0, 1, 0);
  vec3 right = vec3(1, 0, 0);

  float u = (vUv.x * 16.0) - 8.0;
  float v = (vUv.y * 9.0) - 4.5;
  float f = 5.0;

  vec3 rd = normalize(cross(up, right));
  vec3 ro = eye + (right * u) + (up * v);// + (rd * f);
  vec3 light = normalize(
    vec3(
      5.0 * sin(time / 60.0),
      5.0 * sin(sin(time / 40.0)),
      5.0 * cos(time / 50.0)));

  float distance = castRay(ro, rd);

  // Surface normal
  vec3 pos = ro + rd * distance;
  vec3 surfaceNormal = calculateNormal(pos);
  float diffusion = 1.5 * clamp(dot(surfaceNormal, light), 0.0, 1.0);


  vec4 color = vec4(1.0, 0.5, 0.1, 1.0);
  color += diffusion * vec4(0.9, 0.5, 0.5, 1.0);
  if (distance > 40.0) {
    color = vec4(0.0);
  }

  // Fog
  vec4 fog = vec4(0.5, 0.6, 0.7, 1.0);
  float mixer =  1.0 - exp(-distance * 0.07);
  color = mix(color, fog, mixer);

  gl_FragColor = color;
}
