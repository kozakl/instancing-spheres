package utils
{
	import alternativa.engine3d.core.*;
	/**
	 * @author kozakluke@gmail.com
	 */
	public final class MathUtil
	{
		static public const RADIANS:Number = Math.PI / 180;
		static public const DEGREES:Number = 180 / Math.PI;
		
		static public function rndRange(min:Number, max:Number):Number 
		{
			return min + (Math.random() * (max - min));
		}
		
		static public function rndIntRange(min:int, max:int):int 
		{
			return Math.round(MathUtil.rndRange(min, max));
		}
		
		static public function toRadians(degrees:Number):Number
		{
			return degrees * RADIANS;
		}
		
		static public function toDegrees(radians:Number):Number
		{
			return radians * DEGREES;
		}
		
		static public function pointToLineDistance(ax:Number, ay:Number, bx:Number, by:Number, px:Number = 0, py:Number = 0):Number
		{
			const ab:Number = Math.sqrt((bx - ax) * (bx - ax) + (by - ay) * (by - ay));
			const bp:Number = Math.sqrt((px - bx) * (px - bx) + (py - by) * (py - by));
			const pa:Number = Math.sqrt((ax - px) * (ax - px) + (ay - py) * (ay - py));
			
			const tp:Number = (ab + bp + pa) * 0.5;
			const ta:Number = Math.sqrt(tp * (tp - ab) * (tp - bp) * (tp - pa));
			
			return 2 * (ta / ab);
		}
		
		static public function lookAt(target:Object3D, x:Number, y:Number, z:Number):void
		{
			const dx:Number = x - target.x;
			const dy:Number = y - target.y;
			const dz:Number = z - target.z;
			target.rotationX = Math.atan2(dz, Math.sqrt(dx * dx + dy * dy)) - Math.PI * 0.5;
			target.rotationY = 0;
			target.rotationZ = -Math.atan2(dx, dy);
		}
	}
}