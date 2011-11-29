package com.netoleal.facebook.connections.model
{
	import asf.core.models.app.BaseModel;
	
	public class WallPostApplicationModel extends BaseModel
	{
		public function WallPostApplicationModel(p_raw:*)
		{
			super(p_raw);
		}
		
		public function get canvasName( ):String
		{
			return raw.canvas_name;
		}
		
		public function get id( ):String
		{
			return raw.id;
		}
		
		public function get name( ):String
		{
			return raw.name;
		}
		
		public function get namespace( ):String
		{
			return raw.namespace;
		}
	}
}