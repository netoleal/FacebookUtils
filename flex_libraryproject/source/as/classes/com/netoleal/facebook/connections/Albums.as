package com.netoleal.facebook.connections
{
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.facebook.graph.Facebook;
	import com.netoleal.facebook.connections.model.AlbumModel;
	import com.netoleal.facebook.members.FacebookUser;
	
	import flash.net.URLRequestMethod;
	
	public class Albums extends BaseConnection
	{
		private var loadSeq:Sequence;
		private var createAlbumSeq:Sequence;
		
		private var _albums:Vector.<AlbumModel>;
		
		public function Albums(p_user:FacebookUser)
		{
			super(p_user);
			
			loadSeq = new Sequence( );
			createAlbumSeq = new Sequence( );
		}
		
		public function createNew( name:String, description:String = "", privacy:String = "EVERYONE" ):ISequence
		{
			createAlbumSeq.notifyStart( );
			
			Facebook.api( _user.id + "/albums", onAlbumCreateComplete, {
				name: name,
				message: description,
				privacy: { value: privacy }
			}, URLRequestMethod.POST );
			
			return createAlbumSeq;
		}
		
		private function onAlbumCreateComplete( result:Object, error:Object ):void
		{
			log( arguments );
			
			createAlbumSeq.notifyComplete( result );
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