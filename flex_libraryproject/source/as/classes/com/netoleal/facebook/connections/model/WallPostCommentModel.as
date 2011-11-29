package com.netoleal.facebook.connections.model
{
	import asf.core.models.app.BaseModel;
	
	import com.netoleal.facebook.members.FacebookUser;
	import com.netoleal.facebook.members.FacebookUserFactory;
	
	public class WallPostCommentModel extends BasePostEntityModel
	{
		public function WallPostCommentModel(p_raw:*)
		{
			super(p_raw);
		}
		
		public function get likesCount( ):uint
		{
			return raw.likes;
		}
	}
}