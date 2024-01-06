precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 color = texture2D(tex, v_texcoord);

    // https://en.wikipedia.org/wiki/Rec._709#Luma_coefficients
    // float gray = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));

    // https://en.wikipedia.org/wiki/Rec._2100#Luma_coefficients
    float gray = dot(color.rgb, vec3(0.2627, 0.6780, 0.0593));

    gl_FragColor = vec4(vec3(gray), color.a);
}
