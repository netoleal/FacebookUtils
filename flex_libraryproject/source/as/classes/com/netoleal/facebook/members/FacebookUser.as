package com.netoleal.facebook.members 
{ 
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import com.facebook.graph.Facebook;
	import com.netoleal.facebook.connections.Connections;
	import com.netoleal.facebook.events.UserEvent;
	import com.netoleal.facebook.net.ImageUploader;
	
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	[Event( name="complete", type="flash.events.Event")]
	
	public class FacebookUser extends Connections
	{
		public static const GENDER_MALE:String = "male";
		public static const GENDER_FEMALE:String = "female";
		
		private var _friendsCallback:Function;
		
		private var uid:String;
		private var raw:Object;
		private var _loaded:Boolean = false;
		private var _loading:Boolean = false;
		
		private var loadSequence:ISequence;
		private var friendsSequence:ISequence;
		private var _connections:Connections;
		private var tagSeq:Sequence;
		
		public function FacebookUser( p_uid:String, p_raw:Object = null )
		{
			super( this );
			
			uid = p_uid;
			if( p_raw )
			{
				raw = p_raw;
				_loaded = true;
			}
			
			loadSequence = new Sequence( );
			friendsSequence = new Sequence( );
			tagSeq = new Sequence( );
		}
		
		public function tagOnPhoto( photoID:String, x:uint = 0, y:uint = 0 ):ISequence
		{
			tagSeq.notifyStart( );
			
			Facebook.api( photoID + "/tags", onCreateTag, { to: this.id, x: x, y: y }, URLRequestMethod.POST );
			
			return tagSeq;
		}
		
		private function onCreateTag( result:Object, error:Object ):void
		{
			tagSeq.notifyComplete( result != null, result );
		}
		
		public function uploadPhoto( image:BitmapData, description:String = "" ):ISequence
		{
			return new ImageUploader( ).uploadPhoto( id, image, description );
		}
		
		public function get rawData( ):Object
		{
			return raw;
		}
		
		public function get loading( ):Boolean
		{
			return _loading;
		}
		
		public function get loaded( ):Boolean
		{
			return _loaded;
		}
		
		public function load( ):ISequence
		{
			loadSequence.notifyStart( );
			
			if( this.loaded )
			{
				this.dispatchComplete( );
			}
			else if( !this._loading )
			{
				this._loading = true;
				Facebook.api( "/" + uid, onLoad );
			}
			
			return loadSequence;
		}
		
		public function clearLoadSequence( ):void
		{
			loadSequence.dispose( );
		}
		
		public function get profilePictureURL( ):String
		{
			var url:String = Facebook.getImageUrl( this.id );
			return url;
		}
		
		public function get profileLargePictureURL( ):String
		{
			var url:String = Facebook.getImageUrl( this.id, "large" );
			
			return url;
		}
		
		private function onLoad( userInfo:Object, error:Object ):void
		{
			this._loading = false;
			
			if( userInfo )
			{
				this._loaded = true;
				raw = userInfo;
				
				if( isNaN( Number( uid ) ) )
				{
					FacebookUserFactory.getUser( raw.id, raw );
				}
				
				this.dispatchComplete( );
			}
			else
			{
				log( error );
				loadSequence.notifyComplete( false );
				this.dispatchEvent( new ErrorEvent( ErrorEvent.ERROR ) );
			}
		}
		
		private function dispatchComplete( ):void
		{
			loadSequence.notifyComplete( true );
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get timeZone( ):int
		{
			return raw.timezone;
		}
		
		public function get gender( ):String
		{
			return raw.gender;
		}
		
		public function get verified( ):Boolean
		{
			return raw.verified;
		}
		
		public function get lastName( ):String
		{
			return raw.last_name;
		}
		
		public function get locale( ):String
		{
			return raw.locale
		}
		
		public function get link( ):String
		{
			return raw.link;
		}
		
		public function get updatedTime( ):String
		{
			return raw.updated_time;
		}
		
		public function get fullName( ):String
		{
			return firstName + " " + lastName;
		}
		
		public function get firstName( ):String
		{
			return raw.first_name;
		}
		
		public function get id( ):String
		{
			return uid;//raw.id;
		}
		
		public function dispose( ):void
		{
			FacebookUserFactory.removeUser( this );
			raw = null;
		}
	}
}