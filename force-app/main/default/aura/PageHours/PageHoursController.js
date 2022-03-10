({
    doInit : function(component, event, helper) {

        var ln =window.navigator.language;
        var listOfColumns=[];
        if(ln=="es"){

            listOfColumns=
            [
                {label:'Seleccionar Todos',value:'GOT_Todos'},
                {label:'Nombre',value:'GOT_Name'},
                {label:'Categoría',value:'GOT_Categoria'},
                {label:'Fecha',value:'GOT_Fecha'},
                {label:'Horas',value:'GOT_Horas'},
                {label:'Tarifa',value:'GOT_Tarifa'},
                {label:'Importe',value:'GOT_Importe'},
                {label:'Descripcion',value:'GOT_Descripcion'}
            ];

        }else if(ln=="en-US"){

            listOfColumns=
            [
                {label:'Select all',value:'GOT_Todos'},
                {label:'Name',value:'GOT_Name'},
                {label:'Category',value:'GOT_Categoria'},
                {label:'Date',value:'GOT_Fecha'},
                {label:'Hours',value:'GOT_Horas'},
                {label:'Rate',value:'GOT_Tarifa'},
                {label:'Amount',value:'GOT_Importe'},
                {label:'Description',value:'GOT_Descripcion'}
            ];

        }else{

            listOfColumns=
            [
                {label:'Seleziona tutti',value:'GOT_Todos'},
                {label:'Nomed',value:'GOT_Name'},
                {label:'Categoria',value:'GOT_Categoria'},
                {label:'Data',value:'GOT_Fecha'},
                {label:'Ore',value:'GOT_Horas'},
                {label:'Tariffa',value:'GOT_Tarifa'},
                {label:'Importo',value:'GOT_Importe'},
                {label:'Descrizione',value:'GOT_Descripcion'}
            ];

        }

        component.set("v.listOfColumns",listOfColumns);
        var invoiceId= component.get('v.recordId');
        component.set("v.iFrameURL",'/apex/GOT_PDFInvoiceHours?id=' + invoiceId + '&language=' + ln);

       
    },
    
    metodoOnChange: function(component, event, helper) {
        
        var invoiceId= component.get('v.recordId');
        var valores=event.getParam("value");
        var ln =window.navigator.language;
      component.set("v.iFrameURL",'/apex/GOT_PDFInvoiceHours?id=' + invoiceId + '&language=' + ln + '&cols=' + valores);
    },

    toggle : function(component, event, helper) {
        var toggleText = component.find("selectOptions");
        $A.util.toggleClass(toggleText, "toggle");
    }
    
    
})
