/***************************************************************************
sat_reparaciones.qs  -  description
-------------------
begin                : lun ago 8 2011
copyright            : (C) 2011 by Easy Soft Community
email                : contacto@easysoftcommunity.com
***************************************************************************/

/***************************************************************************
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
***************************************************************************/

/** @file */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
  var ctx:Object;
  function interna( context ) { this.ctx = context; }
  function init() { this.ctx.interna_init(); }
//   function calculateCounter():String { return this.ctx.interna_calculateCounter(); }
  function validateForm():Boolean { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
  function oficial( context ) { interna( context ); } 
  function bufferChanged(fN:String) {
	return this.ctx.oficial_bufferChanged(fN);
  }

}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
  function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
  function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \D Funcion Init
\end */
function interna_init()
{
  var util:FLUtil = new FLUtil();
  var cursor:FLSqlCursor = this.cursor();
//   
  connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
  
}

/** \D Calcula un nuevo número de consulta
\end */
// function interna_calculateCounter()
// {
//   var util:FLUtil = new FLUtil();
//   return util.nextCounter("codcita", this.cursor());
// }

function interna_validateForm()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var Fecha:String = cursor.valueBuffer("fecha").toString();
	var retFecha:String = Fecha.left( Fecha.length - 9);
	
	var DesdeHora:String = cursor.valueBuffer("desdehora").toString();
	var retDesdeHora:String = DesdeHora.right( DesdeHora.length - 11);
	
	var HastaHora:String = cursor.valueBuffer("hastahora").toString();
	var retHastaHora:String = HastaHora.right( HastaHora.length - 11);
	
	var CodigoCita:String = retFecha + "-" + retDesdeHora + "-" + retHastaHora;
	
	debug("Fecha = " + retFecha);
	debug("DesdeHora = " + retDesdeHora);
	debug("HastaHora = " + retHastaHora);
	debug("CodigoCita = " + CodigoCita);
	
	cursor.setValueBuffer("codigo", CodigoCita);

	return true;
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////


function oficial_bufferChanged(fN:String)
{
  var util:FLUtil = new FLUtil();
  var cursor:FLSqlCursor = this.cursor();
//   
//   switch (fN) {
// 
//   }
}



//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
