package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import alternativa.engine3d.controllers.*;
	import alternativa.engine3d.core.*;
	import com.greensock.*;
	import utils.*;
	/**
	 * @author kozakluke@gmail.com
	 */
	public final class CameraController extends SimpleObjectController
	{
		public var isDragging:Boolean;
		
		private var startMouseY:Number, startMouseX:Number;
		private var enabled:Boolean = true;
		private var startPos:Vector3D;
		private var stage:Stage;
		
		public final function CameraController(stage:Stage, object:Object3D)
		{
			super(stage, object, 100);
			this.stage = stage;
			
			mouseSensitivity = 0;
            unbindAll();
            setObjectPosXYZ(0, 1, 10 * MathUtil.RADIANS);
            lookAtXYZ(0, 0, 0);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		public final function setEnable(value:Boolean):void
		{
			enabled = value;
			if (enabled)
				enable();
			else disable();
		}
		
		private final function onDown(event:MouseEvent):void
		{
			if (!enabled)
				return;
			
            startMouseY = stage.mouseY;
			startMouseX = stage.mouseX;
			startPos = new Vector3D(object.x, object.y, object.z);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private final function onUp(event:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			isDragging = false;
		}
		
		private const m:Matrix3D = new Matrix3D();
		private final function onMove(event:MouseEvent):void 
		{
			if (!isDragging)
				isDragging = true;
			
			m.identity();
			m.appendRotation((stage.mouseX - startMouseX) * 0.15, Vector3D.Z_AXIS);
    		m.appendRotation((stage.mouseY - startMouseY) * 0.15, Vector3D.X_AXIS);
			
			const v:Vector3D = m.transformVector(startPos);
			
			TweenLite.to(object, 0.35, {x:v.x, y:v.y, z:v.z});
		}
		
		override public final function update():void
		{
			updateObjectTransform();
		    lookAtXYZ(0, 0, 0);
			
			super.update();
		}
		
		public final function destroy():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
	}
}
