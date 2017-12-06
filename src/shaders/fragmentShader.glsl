#version 400 core

in vec2 pass_textureCoords;
in vec3 surfaceNormal;
in vec3 relativeLightPosition;
in vec3 relativePosition;
in float visibility;

out vec4 out_Color;

uniform sampler2D textureSampler;
uniform vec3 lightColour;
uniform float shineDamper;
uniform float reflectivity;
uniform vec3 skyColor;

void main() {
    vec3 unitNormal = normalize(surfaceNormal);
    vec3 unitLightVector = normalize(relativeLightPosition - relativePosition);

    float brightness = max(dot(unitNormal, unitLightVector), 0.2);
    vec3 diffuse = brightness * lightColour;

    vec3 unitCameraVector = normalize(-relativePosition);
    vec3 unitHalfDirection = normalize(unitLightVector + unitCameraVector);
    float specularFactor = max(dot(unitNormal, unitHalfDirection), 0);
    float dampedFactor = pow(specularFactor, shineDamper);
    vec3 finalSpecular = dampedFactor * reflectivity * lightColour;

    vec4 textureColor = texture(textureSampler, pass_textureCoords);
    if(textureColor.a<0.5)
        discard;

    out_Color = vec4(diffuse, 1) * textureColor + vec4(finalSpecular, 1);
    out_Color = mix(vec4(skyColor, 1), out_Color, visibility);
}