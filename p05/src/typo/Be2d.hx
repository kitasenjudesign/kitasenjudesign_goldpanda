package typo;
import three.Vector2;

/**
 * ...
 * @author nab
 */
class Be2d
{

		
		//始点
		private var _point0:Vector2;
		//終点
		private var _point1:Vector2;
		//コントロール点
		private var _control:Vector2;
		
		//線の長さ
		private var _length:Float = 0;
		
		//積分の定数系
		private var XY		:Float;
		private var B		:Float;
		private var C		:Float;
		private var CS		:Float;
		private var CS2		:Float;
		private var INTG_0	:Float;
	
	
	public function new(p0:Vector2, p1:Vector2, ctrl:Vector2) 
	{
		_point0 = p0;
		_point1 = p1;
		_control = ctrl;
		//trace(_point0 + " " + _point1 +" " + _control);
		setPoints(_point0, _point1, ctrl);
	}
	
		
		/**
		* ベジェ関数
		* @param	t( 0～1.0 )
		* @return	座標
		*/
		public function f(t:Float):Vector2{
			var tp:Float = 1.0 - t;
			return new Vector2( _point0.x*tp*tp + 2*_control.x*t*tp + _point1.x*t*t,
			                  _point0.y*tp*tp + 2*_control.y*t*tp + _point1.y*t*t );
		}
		
		/**
		* ベジェ関数微分
		* @param	t( 0～1.0 )
		* @return	ベクトル
		*/
		public function diff(t:Float):Vector2{
			return new Vector2( 2*( t*( _point0.x + _point1.x - 2*_control.x ) - _point0.x + _control.x ) ,
			                  2*( t*( _point0.y + _point1.y - 2*_control.y ) - _point0.y + _control.y ) );
		}
		
		/**
		* ベジェ関数積分(0からt)
		* @param	t( 0～1.0 )
		* @return	積分値
		*/
		public function integral(t:Float):Float{
			return (integralBezje(t) - INTG_0);
		}
		
		/**
		* 2次元ベジェ曲線の長さ
		* @return	長さ
		*/
		public function getLength():Float{
			return _length;
		}
		
		
		//--------------------------------------------------------------------
		
		/**
		* 積分定数初期化
		*/
		private function integralInit():Void{
			var kx:Float = _point0.x + _point1.x - 2 * _control.x;
			var ky:Float = _point0.y + _point1.y - 2 * _control.y;
			var ax:Float = - _point0.x + _control.x;
			var ay:Float = - _point0.y + _control.y;
			//trace("integralInit " + ax +" " + kx + " " + XY);
			//積分計算の為の定数
			XY = kx*kx + ky*ky;
			B  = ( ax*kx + ay*ky )/XY;
			C  = ( ax*ax + ay*ay )/XY - B*B;
			if( C>1e-10 ){
				CS  = Math.sqrt(C);
				CS2 = 0.0;
			}else{
				C = 0;
				CS = CS2 = 1.0;
			}
			//trace(C + " " + CS +" " + CS2);
			INTG_0  = integralBezje(0.0);
			//trace(INTG_0);
			//長さ
			_length = integral(1.0);
			//trace("len = "+_length);
		}
		
		/**
		* 積分関数
		* @param	t( 0～1.0 )
		* @return	積分結果
		*/
		private function integralBezje( t:Float ):Float{
			var BT:Float  = B + t;
			var BTS:Float = Math.sqrt( BT * BT + C );
			//trace("AA" + B +" " + t +" " + BTS + " " +XY + " " + CS);
			return Math.sqrt(XY) * ( BTS*BT + C * Math.log( (BT + BTS)/CS + CS2 ) );
		}
		
		//--------------------------------------------------------------------
		
		/**
		* 長さからtを得る
		* @param	長さ( 0～length )
		* @param	許容誤差
		* @return t
		*/
		public function length2T( len:Float, d:Float=0.1 ):Float{
			if( len<0 || len>_length ){
				return 0;
			}else{
				return seekL( len, d );
			}
		}
		
		/**
		* 長さに対するtを得る
		* @param	長さ( 0～length )
		* @param	許容誤差
		* @param	チェックt値
		* @param	次のチェックt値差分
		* @return t
		*/
		
		//0.5,16,0.25,0.1,0
		private function seekL( len:Float, d:Float = 0.1, t0:Float = 0.5, td:Float = 0.25  ):Float {
			
			
			var lent0:Float = integral(t0);
			//trace(len, lent0, t0, d, td);
			//trace("td" + td);
			if (td <= 0.01) return t0;
			
			if( Math.abs( len-lent0 )<d ){
				return t0;
			}else{
				return seekL( len, d, (lent0<len) ? t0+td : t0-td, td/2 );
			}
		}
		
		//--------------------------------------------------------------------
		
		/**
		* 描画
		* @param Graphics
		*/
		//public function draw( g:Graphics ):Void{
			//g.moveTo( _point0.x, _point0.y );
			//g.curveTo( _control.x, _control.y, _point1.x, _point1.y );
		//}
		
		//--------------------------------------------------------------------
		
		/*
		public function get point0():Point{
			return _point0.clone();
		}
		public function get point1():Point{
			return _point1.clone();
		}
		public function get control():Point{
			return _control.clone();
		}
		
		public function set point0(p:Point):void{
			_point0 = p;
			integralInit();
		}
		public function set point1(p:Point):void{
			_point1 = p;
			integralInit();
		}
		public function set control(p:Point):void{
			_control = p;
			integralInit();
		}*/
		
		public function setPoints( p0:Vector2, p1:Vector2, ctrl:Vector2 ):Void{
			_point0  = p0;
			_point1  = p1;
			_control = ctrl;
			integralInit();
		}

	
	
}