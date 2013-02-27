package 
{
	import alternativa.engine3d.core.*;
	import alternativa.engine3d.materials.*;
	import alternativa.engine3d.objects.*;
	import alternativa.engine3d.resources.*;
	import flash.display.*;
	import flash.events.*;
	import utils.*;
	/**
	 * @author kozakluke@gmail.com
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="600")]
	public final class Main extends Sprite
	{
		private var cameraController:CameraController;
		private var stage3D:Stage3D;
		private var scene:Object3D;
		private var camera:Camera3D;
		
		public final function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onCreateContext);
			stage3D.requestContext3D();
		}
		
		private final function onCreateContext(event:Event):void 
		{
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onCreateContext);
			
			scene = new Object3D();
			const cameraContainer:Object3D = new Object3D();
			scene.addChild(cameraContainer);
			camera = new Camera3D(0.1, 115000);
			cameraContainer.addChild(camera);
			
			camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 0);
			addChild(camera.view);
			addChild(camera.diagram);
			camera.rotationX = -90 * Math.PI / 180;
			camera.y = -500;
			
			cameraController = new CameraController(stage, cameraContainer);
			
			for (var i:int = 0; i < 204; ++i)
				create();
			create(700);
			
			for each (var resource:Resource in scene.getResources(true))
				resource.upload(stage3D.context3D);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);	
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}

		private final function onWheel(event:MouseEvent):void
		{
			camera.y -= event.delta;
		}
		
		private final function create(num:int = 910):void
		{
			const indices:Vector.<uint> = new Vector.<uint>();
			for (var i:int = 0; i < num * 72; ++i)
				indices[indices.length] = i;
			
			const uv:Vector.<Number> = new Vector.<Number>();
			for (i = 0; i < num; ++i)
				uv.push(1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1,
						1, 1, 1, 1, 1, 1);
			
			const vertices:Vector.<Number> = new <Number>[];
			for (i = 0; i < num; ++i)
			{
                const px:Number = MathUtil.rndRange(-130, 130);
                const py:Number = MathUtil.rndRange(-130, 130);
                const pz:Number = MathUtil.rndRange(-130, 130);
				
				createSphere(vertices, 0.003, px, py, pz);
			}
			
			const attributes:Array = new Array();
			attributes[0] = VertexAttributes.POSITION;
			attributes[1] = VertexAttributes.POSITION;
			attributes[2] = VertexAttributes.POSITION;
			attributes[3] = VertexAttributes.TEXCOORDS[0];
			attributes[4] = VertexAttributes.TEXCOORDS[0];
			
			const geometry:Geometry = new Geometry();
			geometry.addVertexStream(attributes);
			geometry.numVertices = 72 * num;
			geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], uv);
			geometry.indices = indices;
			
			const mesh:Mesh = new Mesh();
			mesh.geometry = geometry;
			mesh.addSurface(new FillMaterial(0x9933FF), 0, 24 * num);
			scene.addChild(mesh);
		}
		
		private final function createSphere(vertices:Vector.<Number>, s:Number, x:Number, y:Number, z:Number):void
		{
						  //front
			vertices.push( 0       + x,  170 * s + y,  0       + z,
						   100 * s + x,  100 * s + y, -100 * s + z,
						  -100 * s + x,  100 * s + y, -100 * s + z,
						   
						   0       + x,  170 * s + y,  0       + z,
						  -100 * s + x,  100 * s + y, -100 * s + z,
						  -100 * s + x,  100 * s + y,  100 * s + z,
						   
						   0  	   + x,  170 * s + y,  0       + z,
						  -100 * s + x,  100 * s + y,  100 * s + z,
						   100 * s + x,  100 * s + y,  100 * s + z,
						   
						   0	   + x,  170 * s + y,  0       + z,
						   100 * s + x,  100 * s + y,  100 * s + z,
						   100 * s + x,  100 * s + y, -100 * s + z,
						   
						   //back
						   0	   + x, -170 * s + y,  0       + z,
						  -100 * s + x, -100 * s + y, -100 * s + z,
						   100 * s + x, -100 * s + y, -100 * s + z,
						   
						   0       + x, -170 * s + y,  0       + z,
						  -100 * s + x, -100 * s + y,  100 * s + z,
						  -100 * s + x, -100 * s + y, -100 * s + z,
						   
						   0 	   + x, -170 * s + y,  0       + z,
						   100 * s + x, -100 * s + y,  100 * s + z,
						  -100 * s + x, -100 * s + y,  100 * s + z,
						   
						   0       + x, -170 * s + y,  0       + z,
						   100 * s + x, -100 * s + y, -100 * s + z,
						   100 * s + x, -100 * s + y,  100 * s + z,
						   
						   //top
						   0       + x,  0       + y,  170 * s + z,
						   100 * s + x,  100 * s + y,  100 * s + z,
						  -100 * s + x,  100 * s + y,  100 * s + z,
						   
						   0	   + x,  0       + y,  170 * s + z,
						  -100 * s + x,  100 * s + y,  100 * s + z,
						  -100 * s + x, -100 * s + y,  100 * s + z,
						   
						   0	   + x,  0       + y,  170 * s + z,
						  -100 * s + x, -100 * s + y,  100 * s + z,
						   100 * s + x, -100 * s + y,  100 * s + z,
						   
						   0	   + x,  0       + y,  170 * s + z,
						   100 * s + x, -100 * s + y,  100 * s + z,
						   100 * s + x,  100 * s + y,  100 * s + z,
						   
						   //bottom
						   0	   + x,  0       + y, -170 * s + z,
						  -100 * s + x,  100 * s + y, -100 * s + z,
						   100 * s + x,  100 * s + y, -100 * s + z,
						   
						   0	   + x,  0       + y, -170 * s + z,
						  -100 * s + x, -100 * s + y, -100 * s + z,
						  -100 * s + x,  100 * s + y, -100 * s + z,
						   
						   0	   + x,  0       + y, -170 * s + z,
						   100 * s + x, -100 * s + y, -100 * s + z,
						  -100 * s + x, -100 * s + y, -100 * s + z,
						   
						   0	   + x,  0       + y, -170 * s + z,
						   100 * s + x,  100 * s + y, -100 * s + z,
						   100 * s + x, -100 * s + y, -100 * s + z,
						   
						   //right
						  -170 * s + x,  0       + y,  0       + z,
						  -100 * s + x,  100 * s + y,  100 * s + z,
						  -100 * s + x,  100 * s + y, -100 * s + z,
						   
						  -170 * s + x,  0       + y,  0       + z,
						  -100 * s + x,  100 * s + y, -100 * s + z,
						  -100 * s + x, -100 * s + y, -100 * s + z,
						   
						  -170 * s + x,  0       + y,  0       + z,
						  -100 * s + x, -100 * s + y, -100 * s + z,
						  -100 * s + x, -100 * s + y,  100 * s + z,
						   
						  -170 * s + x,  0       + y,  0       + z,
						  -100 * s + x, -100 * s + y,  100 * s + z,
						  -100 * s + x,  100 * s + y,  100 * s + z,
						   
						   //left
						   170 * s + x,  0       + y,  0       + z,
						   100 * s + x,  100 * s + y, -100 * s + z,
						   100 * s + x,  100 * s + y,  100 * s + z,
						   
						   170 * s + x,  0       + y,  0       + z,
						   100 * s + x, -100 * s + y, -100 * s + z,
						   100 * s + x,  100 * s + y, -100 * s + z,
						   
						   170 * s + x,  0       + y,  0       + z,
						   100 * s + x, -100 * s + y,  100 * s + z,
						   100 * s + x, -100 * s + y, -100 * s + z,
						   
						   170 * s + x,  0       + y,  0       + z,
						   100 * s + x,  100 * s + y,  100 * s + z,
						   100 * s + x, -100 * s + y,  100 * s + z);
		}
		
		private final function onUpdate(event:Event):void 
		{
			cameraController.update();
			camera.render(stage3D);
		}
	}
}
