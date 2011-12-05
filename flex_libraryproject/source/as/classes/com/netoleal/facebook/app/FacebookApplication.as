package com.netoleal.facebook.app
{
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookSession;
	import com.netoleal.facebook.events.FacebookApplicationEvent;
	import com.netoleal.facebook.members.FacebookUser;
	import com.netoleal.facebook.members.FacebookUserFactory;
	
	import flash.events.EventDispatcher;
	
	[Event(name="userLoadStart", type="com.netoleal.facebook.events.FacebookApplicationEvent")]
	[Event(name="userLoadComplete", type="com.netoleal.facebook.events.FacebookApplicationEvent")]
	
	public class FacebookApplication extends EventDispatcher
	{
		private var _id:String;
		
		private var _initCallback:Function;
		
		public var facebookSession:FacebookSession;
		public var user:FacebookUser;
		
		private var initSeq:Sequence;
		private var userSeq:Sequence;
		private var loginSeq:Sequence;
		
		public function FacebookApplication( applicationID:String ):void
		{
			_id = applicationID;
			
			initSeq = new Sequence( );
			userSeq = new Sequence( );
			loginSeq = new Sequence( );
		}
		
		public function init( p_token:String = "" ):ISequence
		{
			initSeq.notifyStart( );
			
			log( _id, p_token );
			
			Facebook.init( _id, initCallback, { }, p_token );
			
			return initSeq;
		}
		
		public function loginUser( ... permissions ):ISequence
		{
			loginSeq.notifyStart( );
			
			this.dispatchEvent( new FacebookApplicationEvent( FacebookApplicationEvent.LOGIN_START ) );
			
			Facebook.login( onLogin, { scope: [ ].concat( permissions ).join( "," ) } );
			
			return loginSeq;
		}
		
		private function onLogin( result:Object, error:Object ):void
		{
			if( result )
			{
				//loadCurrentUser( )
				if( !loginSeq.completed )
				{
					loginSeq.notifyComplete( true );
					this.dispatchEvent( new FacebookApplicationEvent( FacebookApplicationEvent.LOGIN_COMPLETE ) );
				}
			}
			else
			{
				loginSeq.notifyComplete( false );
				this.dispatchEvent( new FacebookApplicationEvent( FacebookApplicationEvent.LOGIN_FAIL ) );
			}
		}
		
		private function initCallback( session:Object, error:Object ):void
		{
			facebookSession = session as FacebookSession;
			
			if( !session )
			{
				_initCallback.apply( null, [ session, error ] );
				initSeq.notifyComplete( false );
			}
			else
			{
				loadCurrentUser( );
			}
		}
		
		public function loadCurrentUser( ):ISequence
		{
			userSeq.notifyStart( );
			
			this.dispatchEvent( new FacebookApplicationEvent( FacebookApplicationEvent.USER_LOAD_START ) );
			
			Facebook.api( "/me", onLoadUser );
			
			return userSeq;
		}
		
		private function onLoadUser( _user:Object, _error:Object ):void
		{
			if( _user )
			{
				user = FacebookUserFactory.getUser( _user.id, _user );
				
				log( user.fullName );
				
				this.dispatchEvent( new FacebookApplicationEvent( FacebookApplicationEvent.USER_LOAD_COMPLETE ) );
				
				if( !initSeq.completed ) initSeq.notifyComplete( true );
				if( !loginSeq.completed )
				{
					loginSeq.notifyComplete( true );
					this.dispatchEvent( new FacebookApplicationEvent( FacebookApplicationEvent.LOGIN_COMPLETE ) );
				}
				
				userSeq.notifyComplete( true );
			}
			else
			{
				if( !initSeq.completed ) userSeq.notifyComplete( false );
				if( !loginSeq.completed )
				{
					loginSeq.notifyComplete( false );
				}
				
				initSeq.notifyComplete( false );
			}
		}
		
		public function dispose( ):void
		{
			facebookSession = null;
			user.dispose( );
			user = null;
		}
	}
}