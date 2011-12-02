package com.netoleal.facebook.net
{
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.adobe.images.JPGEncoder;
	import com.facebook.graph.Facebook;
	
	import flash.display.BitmapData;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	public class ImageUploader
	{
		private var uploadSequence:Sequence;
		
		public function uploadPhoto( albumID:String, image:BitmapData, message:String ):ISequence
		{
			uploadSequence = new Sequence( );
			uploadSequence.notifyStart( );
			
			var jpg:ByteArray = new JPGEncoder( 100 ).encode( image );
			
			Facebook.api( albumID + "/photos", onPhotoUploadComplete, {
				source: jpg,
				message: message,
				fileName: "photo_" + Math.random( )
			}, URLRequestMethod.POST );
			
			return uploadSequence;
		}
		
		private function onPhotoUploadComplete( result:Object, error:Object ):void
		{
			uploadSequence.notifyComplete( error == null, result, error );
		}
	}
}