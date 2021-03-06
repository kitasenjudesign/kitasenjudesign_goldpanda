package effect;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageData;
import js.html.Uint8ClampedArray;
import js.html.VideoElement;
import three.ShaderMaterial;
import three.Texture;
import three.WebGLRenderTarget;
import typo.Textures;


class BgShader extends ShaderMaterial
{

	//vertex shader
	private var vv:String = "
	
		varying vec2 vUv;
		void main()
		{
			vUv = uv;
			//position.x = sin(position.y) * 0.1 + position.x;
			vec4 hoge = vec4(position, 1.0);//matrix keisan shinai
			hoge.z = 1.0;
			gl_Position = hoge;
		}	
	
	";

	//fragment shader
	private var ff:String = "
	
		uniform sampler2D texture;
		varying vec2 vUv;                                             
		void main()
		{
			gl_FragColor = texture2D(texture, vUv);
		}	
	
	";
	
	private var _texture	:Texture;
	
	public function new() 
	{
		
		
		//_context
		
		/*
			video = document.getElementById( 'video' );
			texture = new THREE.VideoTexture( video );
			texture.minFilter = THREE.LinearFilter;
			texture.magFilter = THREE.LinearFilter;
			texture.format = THREE.RGBFormat;
		*/
			Textures.init();
		_texture = Textures.getTexture();
		
		super({
			vertexShader: vv,
			fragmentShader: ff,
			uniforms: {
				texture: { type: 't', value: _texture }	
			}			
		});
		this.fog = false;
	}

	/**
	 * update
	 * @param	a
	 * @param	vi
	 */
	public function update(buffer:WebGLRenderTarget):Void {
		
		uniforms.texture.value = buffer;
		
	}

	
	
	
	
}