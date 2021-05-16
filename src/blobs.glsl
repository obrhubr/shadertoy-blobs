#define HASHSCALE1 .1031

float hash11(float p)
{
	vec3 p3  = fract(vec3(p) * HASHSCALE1);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

float lerp(float a, float b, float t)
{
	return a + t * (b - a);
}

float noise(float p)
{
	float i = floor(p);
    float f = fract(p);
    
    float t = f * f * (3.0 - 2.0 * f);
    
    return lerp(f * hash11(i), (f - 1.0) * hash11(i + 1.0), t);
}

float fbm(float x, float persistence, int octaves) 
{
    float total = 0.0;
    float maxValue = 0.0;
    float amplitude = 1.0;
    float frequency = 1.0;
    
    for(int i=0; i<octaves;++i) {
        total += noise(x * frequency) * amplitude;
        maxValue += amplitude;
        amplitude *= persistence;
        frequency *= 2.0;
    }
    
    return (total/maxValue);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    float maxDist = sqrt(iResolution.x * iResolution.x + iResolution.y * iResolution.y);
    float val = 0.0;

    float x1 = fragCoord.x - iResolution.x;
    float y1 = fragCoord.y - iResolution.y;
    float dist1 = sqrt(
    ((x1*x1))+(y1*y1)
    ) - fbm((iGlobalTime / 10.0 - fragCoord.x / 640.0) * 3.0, 0.0, 1) * 120.0;

    if (dist1 < maxDist/2.0) {
        val +=  2.0 / floor(15.0 * (dist1 / maxDist) + 2.0) - 0.2;
    }

    float x2 = fragCoord.x; 
    float y2 = fragCoord.y;
    float dist2 = sqrt(
    ((x2*x2))+(y2*y2)
    ) - fbm((iGlobalTime / 10.0 - fragCoord.x / 640.0) * 3.0, 0.0, 1) * 120.0;

    if (dist2 < maxDist/2.0) {
        val +=  2.0 / floor(15.0 * (dist2 / maxDist) + 2.0) - 0.2;
    }

    fragColor = vec4(val/1.0, 0.0, val/2.0, 1);
}