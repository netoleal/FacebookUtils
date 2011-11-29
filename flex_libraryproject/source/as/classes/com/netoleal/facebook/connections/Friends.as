package com.netoleal.facebook.connections
{
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.facebook.graph.Facebook;
	import com.netoleal.facebook.events.UserEvent;
	import com.netoleal.facebook.members.FacebookFriend;
	import com.netoleal.facebook.members.FacebookUser;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	[Event( name="friendsLoaded", type="com.netoleal.facebook.events.UserEvent")]
	[Event( name="allFriendsDataLoaded", type="com.netoleal.facebook.events.UserEvent")]
	[Event( name="friendDataLoaded", type="com.netoleal.facebook.events.UserEvent")]
	
	public class Friends extends BaseConnection
	{
		private var loadSeq:Sequence;
		private var _friends:Vector.<FacebookFriend>;
		private var _friendsLoaded:uint;
		
		private var _friendsDict:Dictionary;
		
		public function Friends(p_user:FacebookUser)
		{
			super(p_user);
			
			loadSeq = new Sequence( );
			
			_friendsDict = new Dictionary( );
		}
		
		public function load( ):ISequence
		{
			loadSeq.notifyStart( );
			
			if( _friends )
			{
				return loadSeq.notifyComplete( );
			}
			
			_friendsLoaded = 0;
			Facebook.api( "/" + _user.id + "/Friends", onFriendsLoaded );
			
			return loadSeq;
		}
		
		private function onFriendsLoaded( p_friends:Array, error:Object ):void
		{
			var friendRaw:Object;
			var friend:FacebookFriend;
			var n:uint = 0;
			var max:uint = 0;
			
			_friends = new Vector.<FacebookFriend>( );
			p_friends.sortOn( "name" );
			
			for each( friendRaw in p_friends )
			{
				if( max != 0 && n++ >= max ) break;
				
				friend = new FacebookFriend( friendRaw );
				
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
			
			loadSeq.notifyComplete( this );
			this.dispatchEvent( new UserEvent( UserEvent.FRIENDS_LOADED ) );
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
		
		public function searchFriendsByName( name:String ):Vector.<FacebookFriend>
		{
			var dict:Array;
			var friend:FacebookFriend;
			var res:Vector.<FacebookFriend> = new Vector.<FacebookFriend>( );
			
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
		
		private function friendDataLoaded( evt:Event ):void
		{
			_friendsLoaded ++;
			
			var e:UserEvent = new UserEvent( UserEvent.FRIEND_DATA_LOADED );
			e.friend = evt.target as FacebookUser;
			
			this.dispatchEvent( e );
			
			if( _friendsLoaded == items.length )
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
			return items.length;
		}
		
		public function get items( ):Vector.<FacebookFriend>
		{
			return _friends.concat( );
		}
		
		public function dispose( ):void
		{
			if( _friends )
			{
				var friend:FacebookFriend;
				
				for each( friend in items )
				{
					friend.dispose( );
				}
				
				_friends = null;
			}
		}
	}
}