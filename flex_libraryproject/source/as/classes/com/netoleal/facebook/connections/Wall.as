package com.netoleal.facebook.connections
{
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.facebook.graph.Facebook;
	import com.netoleal.facebook.connections.model.WallPostModel;
	import com.netoleal.facebook.members.FacebookUser;
	
	import flash.net.URLRequestMethod;
	
	public class Wall extends BaseConnection
	{
		private var openDialogSeq:Sequence;
		private var postSeq:Sequence;
		private var loadSeq:Sequence;
		private var _posts:Vector.<WallPostModel>;
		
		public function Wall( p_user:FacebookUser )
		{
			super(p_user);
			
			openDialogSeq = new Sequence( );
			postSeq = new Sequence( );
			loadSeq = new Sequence( );
		}
		
		public function load( forceRefresh:Boolean = false ):ISequence
		{
			loadSeq.notifyStart( );
			
			if( !forceRefresh && this._posts )
			{
				return loadSeq.notifyComplete( this );
			}
			
			Facebook.api( "/" + _user.id + "/Feed", onLoadPosts );
			
			return loadSeq;
		}
		
		private function onLoadPosts( result:Object, error:Object ):void
		{
			var postRaw:Object;
			
			_posts = new Vector.<WallPostModel>( );
			
			for each( postRaw in result )
			{
				_posts.push( new WallPostModel( postRaw ) );
			}
			
			loadSeq.notifyComplete( this );
		}
		
		public function get items( ):Vector.<WallPostModel>
		{
			if( !_posts )
			{
				return new Vector.<WallPostModel>( );
			}
			
			return _posts.concat( );
		}
		
		public function post( message:String, caption:String = "", otherProperties:Object = null ):ISequence
		{
			postSeq.notifyStart( );
			
			Facebook.api( "/" + _user.id + "/Feed", onPostComplete, concatObjects ( {
				message: message,
				caption: caption
			}, otherProperties ), URLRequestMethod.POST );
			
			return postSeq;
		}
		
		private function onPostComplete( result:Object, error:Object ):void
		{
			postSeq.notifyComplete( result, error );
		}
		
		public function openDialog( caption:String, description:String, name:String, otherProperties:Object = null ):ISequence
		{
			openDialogSeq.notifyStart( );
			
			Facebook.ui( "/" + _user.id + "/Feed", concatObjects( {
				name: name,
				caption: caption,
				description: description
			}, otherProperties ), onOpenDialogComplete );
			
			return openDialogSeq;
		}
		
		private function onOpenDialogComplete( result:Object, error:Object ):void
		{
			openDialogSeq.notifyComplete( result, error );
		}
	}
}