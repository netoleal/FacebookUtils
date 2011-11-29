package com.netoleal.facebook.connections
{
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.facebook.graph.Facebook;
	import com.netoleal.facebook.connections.model.AlbumModel;
	import com.netoleal.facebook.members.FacebookUser;
	
	public class Albums extends BaseConnection
	{
		private var loadSeq:Sequence;
		private var _albums:Vector.<AlbumModel>;
		
		public function Albums(p_user:FacebookUser)
		{
			super(p_user);
			
			loadSeq = new Sequence( );
		}
		
		public function load( forceRefresh:Boolean = false ):ISequence
		{
			loadSeq.notifyStart( );
			
			if( !forceRefresh && _albums )
			{
				return loadSeq.notifyComplete( this );
			}
			
			Facebook.api( "/" + _user.id + "/Albums", onLoadComplete );
			
			return loadSeq;
		}
		
		private function onLoadComplete( result:Object, error:Object ):void
		{
			var albumRaw:Object;
			
			_albums = new Vector.<AlbumModel>( );
			
			for each( albumRaw in result )
			{
				_albums.push( new AlbumModel( albumRaw ) );
			}
			
			loadSeq.notifyComplete( this );
		}
		
		public function get items( ):Vector.<AlbumModel>
		{
			return _albums;
		}
	}
}