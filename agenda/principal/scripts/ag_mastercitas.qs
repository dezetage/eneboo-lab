/***************************************************************************
                 ost_masterconsultas.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by Easy Soft Community
    email                : mail@infosial.com
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

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
  var ctx:Object;
  function interna( context ) { this.ctx = context; }
  function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration  oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
  var tdbRecords:FLTableDB;
  var fechaDesde;
  var fechaHasta;
  var cbxIntervalos;
  function oficial( context ) { interna( context ); } 
    function intervaloFiltro() {
	return this.ctx.oficial_intervaloFiltro();
  }
  function actualizarFiltro() {
	return this.ctx.oficial_actualizarFiltro();
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
/** \C
Este es el formulario maestro de citas.
\end */
function interna_init()
{
	this.iface.tdbRecords = this.child("tableDBRecords");  

	this.iface.fechaDesde = this.child("dateFrom");
	this.iface.fechaHasta = this.child("dateTo");
	
	this.iface.cbxIntervalos = this.child("cbxIntervalos");

	var mostrarDias = this.iface.intervaloFiltro();
	if (!mostrarDias || isNaN(mostrarDias) || mostrarDias == 0)
		mostrarDias = 1;
	mostrarDias = (mostrarDias * -1 ) + 1;

	var util:FLUtil = new FLUtil;
	var d = new Date();
	this.iface.fechaDesde.date = new Date( util.addDays(d.toString().left(10), mostrarDias) );
	this.iface.fechaHasta.date = new Date();

	connect(this.iface.fechaDesde, "valueChanged(const QDate&)", this, "iface.actualizarFiltro");
	connect(this.iface.fechaHasta, "valueChanged(const QDate&)", this, "iface.actualizarFiltro");
	connect(this.iface.cbxIntervalos, "activated(int)", this, "iface.intervaloFiltro");

	this.iface.actualizarFiltro(); 
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
function oficial_intervaloFiltro()
{ 
    var intervalos = this.iface.cbxIntervalos.currentItem;
    
    var util:FLUtil = new FLUtil;
    var d = new Date ();

	switch (intervalos) {
		case 0: {
			this.iface.fechaDesde.enabled = true;
			this.iface.fechaHasta.enabled = true;
			break;
		}
		case 1: {
			mostrarDias = 0;
			break;
		}
		case 2: {
			mostrarDias = 1;
			break;
		}
		case 3: {
			mostrarDias = 7;
			break;
		}
		case 4: {
			mostrarDias = 30;
			break;
		}
	}

  if (intervalos != 0) {
    this.iface.fechaDesde.date = d.toString().left(10);
    this.iface.fechaHasta.date = util.addDays(d.toString().left(10), mostrarDias); 
    
    //Esto es para que deshabilite los campos si estas usando un intervalo.
    this.iface.fechaDesde.enabled = false;
    this.iface.fechaHasta.enabled = false;
    return mostrarDias;
  }
  
}

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

/** \C
Al fijar las opciones de los filtros se mostrarán las citas que coincidan con los criterios seleccionados
\end */
function oficial_actualizarFiltro()
{
  var desde:String = this.iface.fechaDesde.date.toString().left(10);
  var hasta:String = this.iface.fechaHasta.date.toString().left(10);
  
  if (desde == "" || hasta == "")
	return;
  
  this.cursor().setMainFilter("fecha >= '" + desde + "' AND fecha <= '" + hasta + "'");

  this.iface.tdbRecords.refresh();
  this.cursor().last();
  this.iface.tdbRecords.setCurrentRow(this.cursor().at());
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
