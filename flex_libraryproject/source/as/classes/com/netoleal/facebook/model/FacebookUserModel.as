package com.netoleal.facebook.model 
{ 
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import com.facebook.graph.Facebook;
	import com.netoleal.facebook.events.UserEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	[Event( name="complete", type="flash.events.Event")]
	[Event( name="friendsLoaded", type="com.netoleal.facebook.events.UserEvent")]
	[Event( name="allFriendsDataLoaded", type="com.netoleal.facebook.events.UserEvent")]
	[Event( name="friendDataLoaded", type="com.netoleal.facebook.events.UserEvent")]
	
	public class FacebookUserModel extends EventDispatcher
	{
		public static const GENDER_MALE:String = "male";
		public static const GENDER_FEMALE:String = "female";
		
		private var _friendsCallback:Function;
		
		private var uid:String;
		private var raw:Object;
		private var _loaded:Boolean = false;
		private var _loading:Boolean = false;
		
		private var _friends:Vector.<FacebookFriendModel>;
		private var _friendsLoaded:uint;
		
		private var _friendsDict:Dictionary;
		
		private var loadSequence:ISequence;
		private var friendsSequence:ISequence;
		
		public function FacebookUserModel( p_uid:String, p_raw:Object = null )
		{
			super( null );
			
			uid = p_uid;
			if( p_raw )
			{
				raw = p_raw;
				_loaded = true;
			}
			
			loadSequence = new Sequence( );
			friendsSequence = new Sequence( );
			
			_friendsDict = new Dictionary( );
		}
		
		public function loadFriends( ):ISequence
		{
			friendsSequence.notifyStart( );
			
			if( _friends )
			{
				return friendsSequence.notifyComplete( );
			}
			
			_friendsLoaded = 0;
			Facebook.api( "/" + this.id + "/Friends", onFriendsLoaded );
			
			return friendsSequence;
		}
		
		private function onFriendsServiceError(event:IOErrorEvent):void
		{
			Facebook.api( "/" + this.id + "/Friends", onFriendsLoaded );
		}
		
		private function onFriendsLoaded( p_friends:Array, error:Object ):void
		{
			var friendRaw:Object;
			var friend:FacebookFriendModel;
			var n:uint = 0;
			var max:uint = 0;
			
			_friends = new Vector.<FacebookFriendModel>( );
			p_friends.sortOn( "name" );
			
			for each( friendRaw in p_friends )
			{
				if( max != 0 && n++ >= max ) break;
				
				friend = new FacebookFriendModel( friendRaw );
				
				friend.user.addEventListener( Event.COMPLETE, friendDataLoaded );
				
				if( !_friendsDict[ friend.name.charAt( 0 ).toLowerCase( ) ] )
				{
					_friendsDict[ friend.name.charAt( 0 ).toLowerCase( ) ] = new Array( );
				}
				
				if( !_friendsDict[ friend.name.substr( 0, 2 ).toLowerCase( ) ] )
				{
					_friendsDict[ friend.name.substr( 0, 2 ).toLowerCase( ) ] = new Array( );
				}
				
				_friendsDict[ friend.name.charAt( 0 ).toLowerCase( ) ].push( friend );
				_friendsDict[ friend.name.substr( 0, 2 ).toLowerCase( ) ].push( friend );
				
				_friends.push( friend );
			}
			
			if( this._friendsCallback != null )
			{
				this._friendsCallback( _friends );
			}
			
			friendsSequence.notifyComplete( );
			this.dispatchEvent( new UserEvent( UserEvent.FRIENDS_LOADED ) );
		}
		
		public function searchFriendsByName( name:String ):Vector.<FacebookFriendModel>
		{
			var dict:Array;
			var friend:FacebookFriendModel;
			var res:Vector.<FacebookFriendModel> = new Vector.<FacebookFriendModel>( );
			
			if( name == "" ) return this._friends;
				
			name = name.toLowerCase( );
			dict = name.length == 1? _friendsDict[ name ]: _friendsDict[ name.substr( 0, 2 ) ];
			
			for each( friend in dict )
			{
				if( compareNames( friend.name.substr( 0, name.length ), name ) )
				{
					res.push( friend );
				}
			}
			
			return res;
		}
		
		private function compareNames( name1:String, name2:String ):Boolean
		{
			var subs:Array = [ "áàã,a", "éèê,e", "ç,c", "óôõò,o", "íîì,i", "úùû,u" ];
			var s:String, c:String;
			var a:Array;
			var n:uint;
			
			name1 = name1.toLowerCase( );
			name2 = name2.toLowerCase( );
			
			for each( s in subs )
			{
				a = s.split( "," );
				for( n = 0; n < a[ 0 ].length; n++ )
				{
					c = a[ 0 ].charAt( n );
					name1 = name1.split( c ).join( a[ 1 ] );
					name2 = name2.split( c ).join( a[ 1 ] );
				}
			}
			
			return name1 == name2;
		}
		
		private function friendDataLoaded( evt:Event ):void
		{
			_friendsLoaded ++;
			
			var e:UserEvent = new UserEvent( UserEvent.FRIEND_DATA_LOADED );
			e.friend = evt.target as FacebookUserModel;
			
			this.dispatchEvent( e );
			
			if( _friendsLoaded == friends.length )
			{
				this.dispatchEvent( new UserEvent( UserEvent.ALL_FRIENDS_DATA_LOADED ) );
			}
		}
		
		public function get friendsLoaded( ):uint
		{
			return _friendsLoaded;
		}
		
		public function get friendsTotal( ):uint
		{
			return friends.length;
		}
		
		public function get friends( ):Vector.<FacebookFriendModel>
		{
			return _friends.concat( );
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
	}
}