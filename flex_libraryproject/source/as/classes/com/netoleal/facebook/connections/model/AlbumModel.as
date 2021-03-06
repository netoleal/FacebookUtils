package com.netoleal.facebook.connections.model
{
	import asf.core.models.app.BaseModel;
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.facebook.graph.Facebook;
	import com.netoleal.facebook.members.FacebookUser;
	import com.netoleal.facebook.members.FacebookUserFactory;
	import com.netoleal.facebook.net.ImageUploader;
	
	import flash.display.BitmapData;
	
	public class AlbumModel extends BaseModel
	{
		private var loadSeq:Sequence;
		private var loadPhotosSeq:Sequence;
		
		private var data:Object;
		private var _photos:Vector.<AlbumPhotoModel>;
		
		public function AlbumModel(p_raw:*)
		{
			super( p_raw );
			
			loadSeq = new Sequence( );
			loadPhotosSeq = new Sequence( );
		}
		
		public function uploadPhoto( image:BitmapData, message:String = "" ):ISequence
		{
			return new ImageUploader( ).uploadPhoto( this.id, image, message );
		}
		
		public function load( ):ISequence
		{
			loadSeq.notifyStart( );
			
			if( isLoaded )
			{
				return loadSeq.notifyComplete( this );
			}
			
			Facebook.api( "/" + this.id, onLoadDataComplete );
			
			return loadSeq;
		}
		
		public function clearLoadSequence( ):void
		{
			loadSeq.clearQueue( );
		}
		
		/**
		 * ID da Foto capa do album
		 * Só acessível depois do "load"
		 *  
		 * @return 
		 * 
		 */
		public function get coverPhoto( ):String
		{
			return data.cover_photo;
		}
		
		/**
		 * Quantidade de fotos
		 * Só acessível depois do "load" 
		 * @return 
		 * 
		 */
		public function get countPhotos( ):uint
		{
			return data.count;
		}
		
		/**
		 * Array de objetos com os likes do album
		 * Só acessível depois do "load" 
		 * @return 
		 * 
		 */
		public function get likes( ):Array
		{
			return data.likes.data;
		}
		
		public function get likesPagingNext( ):String
		{
			return data.likes.paging.next;
		}
		
		public function get comments( ):Vector.<AlbumCommentModel>
		{
			if( !( data.comments.data is Vector.<AlbumCommentModel> ) )
			{
				var ar:Array = data.comments.data.concat( );
				var commentRaw:Object;
				
				data.comments.data = new Vector.<AlbumCommentModel>( );
				
				for each( commentRaw in ar )
				{
					data.comments.data.push( new AlbumCommentModel( commentRaw ) );
				}
			}
			
			return data.comments.data;
		}
		
		/**
		 * link para ler comentários da próxima página.
		 * Só acessível depois do "load" 
		 * @return 
		 * 
		 */
		public function get commentsPagingNext( ):String
		{
			return data.comments.paging.next;
		}
		
		public function get isLoaded( ):Boolean
		{
			return data != null;
		}
		
		private function onLoadDataComplete( result:Object, error:Object ):void
		{
			data = result;
			loadSeq.notifyComplete( this );
		}
		
		public function loadPhotos( forceRefresh:Boolean = false ):ISequence
		{
			loadPhotosSeq.notifyStart( );
			
			if( _photos == null || forceRefresh )
			{
				Facebook.api( "/" + this.id + "/photos", onPhotosLoaded );
			}
			else
			{
				return loadPhotosSeq.notifyComplete( this );
			}
			
			return loadPhotosSeq;
		}
		
		private function onPhotosLoaded( result:Object, error:Object ):void
		{
			var photoRaw:Object;
			
			_photos = new Vector.<AlbumPhotoModel>( );
			
			for each( photoRaw in result )
			{
				_photos.push( new AlbumPhotoModel( photoRaw ) );
			}
			
			loadPhotosSeq.notifyComplete( this );
		}
		
		public function get photos( ):Vector.<AlbumPhotoModel>
		{
			return _photos;
		}
		
		public function get canUpload( ):Boolean
		{
			return raw.can_upload;
		}
		
		public function get createdTime( ):Date
		{
			return raw.create_time;
		}
		
		public function get fromUser( ):FacebookUser
		{
			return FacebookUserFactory.getUser( raw.from.id );
		}
		
		public function getFromUserName( ):String
		{
			return raw.from.name;
		}
		
		public function get id( ):String
		{
			return raw.id;
		}
		
		public function link( ):String
		{
			return raw.link;
		}
		
		public function get name( ):String
		{
			return raw.name;
		}
		
		public function get privacy( ):String
		{
			return raw.privacy;
		}
		
		public function get type( ):String
		{
			return raw.type;
		}
		
		public function get updatedTime( ):Date
		{
			return raw.updated_time;
		}
	}
}