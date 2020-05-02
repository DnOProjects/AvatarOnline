#define maxLights 100

struct Light {
    vec2 a;
    vec2 b;
    vec3 color;
    float intensity; //by how much it affects color values
		float spread; //how far around it it affects
    bool isPoint;
};

extern Light lights[maxLights];
extern int numLights;

extern vec2 screenSize;

float distToLine(vec2 p, vec2 a, vec2 b) //copied from internet somewhere
{
  vec2 n = b - a;
   vec2 pa = a - p;
   float c = dot( n, pa );
   if ( c > 0.0 )
       return dot( pa, pa );
   vec2 bp = p - b;
   if ( dot( n, bp ) > 0.0 )
       return dot( bp, bp );
   vec2 e = pa - n * (c / dot( n, n ));
   return dot( e, e );
}

vec4 effect(vec4 drawCol, Image image, vec2 uvs, vec2 pixelPos){
		float scale = min(screenSize.x,screenSize.y); //find shortest side so x and y coords are scaled the same
		pixelPos = pixelPos / scale; //normalise pixel pos to 0-1 relative to screen size
    vec4 textureCol = Texel(image, uvs); //get color of pixel on texture we are drawing

    vec3 netCol = vec3(0);
    for (int i = 0; i < numLights; i++) {
        Light light = lights[i];
        light.a = light.a / scale; //normalise light pos a
        light.b = light.b / scale; //normalise light pos b
				light.spread = light.spread/scale;

        float distance;
        if (light.isPoint){
          distance = length(light.a - pixelPos);
        }else{
          distance = distToLine(pixelPos,light.a,light.b);
        }
        distance = distance/light.spread; //normalise distance to a percentage of light spread

        if (distance<1.0){
          float proximity = pow(1-distance, 3);
  				vec3 lightCol = light.color*(light.intensity+1)*proximity;
          netCol += lightCol;
        }
    }
    netCol = netCol + 1.0; //add minimum light level
    return textureCol*drawCol*vec4(netCol, 1.0);
}
