package com.netoleal.facebook.connections
{
	import com.netoleal.facebook.members.FacebookUser;
	
	import flash.events.EventDispatcher;

	public class Connections extends EventDispatcher
	{
		private var _user:FacebookUser;
		
		private var _wall:Wall;
		private var _friends:Friends;
		private var _albums:Albums;
		
		public function Connections( p_user:FacebookUser )
		{
			_user = p_user;
		}

		public function get albums( ):Albums
		{
			if( !_albums ) _albums = new Albums( _user );
			return _albums;
		}

		public function get friends():Friends
		{
			if( !_friends ) _friends = new Friends( _user );
			return _friends;
		}

		public function get wall( ):Wall
		{
			if( !_wall ) _wall = new Wall( _user );
			return _wall;
		}

	}
}