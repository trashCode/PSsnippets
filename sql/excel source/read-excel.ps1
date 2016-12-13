function updateDB(){

    $excel = new-object -com excel.application
    #$excel.visible = $true

    $wb = $excel.workbooks.open("d:\ANNUAIRE PRESTATAIRES EXTERNES.xls")

    $sheet1 = $excel.Sheets.item(1)
    $sheet1.name
    $sheet1.Columns.count

    $nbLignes = 112
    $rs= @()
    for ($row = 3 ; $row -lt $nbLignes ; $row++){
            $sct = $sheet1.Cells.item($row,1).formula
            $nom = $sheet1.Cells.Item($row,2).formula
            $status = $sheet1.Cells.Item($row,3).formula
            $phone =  $sheet1.Cells.Item($row,4).formula
            $fax =  $sheet1.Cells.Item($row,5).formula
            $mail =  $sheet1.Cells.Item($row,6).formula
            $adresse =  $sheet1.Cells.Item($row,7).formula
            
            
            if ($sct.length -gt 0){$currentSCT = $sct}
            #debug
            echo ($row.toString() + " " + $currentSCT + " " + $nom + " " + $status + " " + $phone + " " + $fax + " " + $mail + " " )
      
            
    }


    #$excel.quit()
}

