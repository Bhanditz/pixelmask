package
{
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.textures.Texture;

	public class PixelMaskScene extends DisplayObjectContainer
	{
		// embed configuration XML
		[Embed(source="../assets/particle.pex", mimeType="application/octet-stream")]
		private static const ParticleConfig:Class;
		
		// embed particle texture
		[Embed(source = "../assets/particle.png")]
		private static const ParticleClass:Class;
		
		[Embed(source="../assets/bg.png")]
		private var BgTexture:Class;
		
		private var _particleContainer:PixelMaskDisplayObject;
		
		public function PixelMaskScene()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		private function handleAddedToStage(event:Event) : void
		{
			// background image
			var background:Image = new Image(Texture.fromEmbeddedAsset(BgTexture));
			addChild(background);
			
			// instantiate embedded objects
			var psConfig:XML = XML(new ParticleConfig());
			var psTexture:Texture = Texture.fromBitmap(new ParticleClass());
			
			// create particle system
			var ps:PDParticleSystem = new PDParticleSystem(psConfig, psTexture);
			ps.x = stage.stageWidth/2;
			ps.y = stage.stageHeight;
			ps.scaleY = -1;
			Starling.juggler.add(ps);
			ps.start();

			// create mask sprite
			var mask:MaskSprite = new MaskSprite();
			mask.x = (stage.stageWidth-mask.width)/2;
			mask.y = (stage.stageHeight-mask.height)/2;
			addEventListener(TouchEvent.TOUCH, handleClick);
			
			// apply the masking here:
			_particleContainer = new PixelMaskDisplayObject();
			
			// NOTE: to test non-animated mode, assign "false" to the second constructor parameter:
			//_particleContainer = new PixelMaskDisplayObject(-1, false);
			
			// uncomment this to see inverted mode:
			//_particleContainer.inverted = true;
			
			addChild(_particleContainer);
			_particleContainer.pixelMask = mask;
			_particleContainer.addChild(ps);
			//_particleContainer.scaleX = _particleContainer.scaleY = .5;
			//_particleContainer.x = _particleContainer.y = 100; 
		}
		
		private function handleClick (e:TouchEvent) : void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			if (touch) _particleContainer.inverted = !_particleContainer.inverted;
		}
	}
}