codeunit 50002 VendorQualityMgt_PKT
{
    procedure CalculateVendorRate(var VendorQuality: Record "Vendor Quality_PKT")
    var
        Handled: Boolean;
    begin
        OnBeforeCalculateVendorRate(VendorQuality, Handled);
        //This is the company's criteria to assign the Vendor rate
        VendorRateCalculation(VendorQuality, Handled);
        OnAfterCalculateVendorRate(VendorQuality);
    end;

    local procedure VendorRateCalculation(var VendorQuality: Record "Vendor Quality_PKT"; var Handled: Boolean)
    begin
        if Handled then
            exit;
        VendorQuality.Rate := (VendorQuality.ScoreDelivery + VendorQuality.ScoreItemQuality + VendorQuality.ScorePackaging + VendorQuality.ScorePricing) / 4;
    end;

    procedure UpdateVendorQualityStatistics(var VendorQuality: Record "Vendor Quality_PKT")
    var
        Year: Integer;
        DW: Dialog;
        DialogMessage: Label 'Calculating Vendor statistics...';
    begin
        DW.Open(DialogMessage);
        Year := Date2DMY(Today, 3);
        VendorQuality.InvoicedYearN := GetInvoicedAmount(VendorQuality."Vendor No.", DMY2Date(1, 1, Year), Today);
        VendorQuality.InvoicedYearN1 := GetInvoicedAmount(VendorQuality."Vendor No.", DMY2Date(1, 1, Year - 1), DMY2Date(31, 12, Year - 1));
        VendorQuality.InvoicedYearN2 := GetInvoicedAmount(VendorQuality."Vendor No.", DMY2Date(1, 1, Year - 2), DMY2Date(31, 12, Year - 2));
        VendorQuality.DueAmount := GetDueAmount(VendorQuality."Vendor No.", TRUE);
        VendorQuality.AmountNotDue := GetDueAmount(VendorQuality."Vendor No.", FALSE);
        DW.Close();
    end;

    local procedure GetInvoicedAmount(VendorNo: Code[20]; StartDate: Date; EndDate: Date): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Total: Decimal;
    begin
        VendorLedgerEntry.SetRange("Vendor No.", VendorNo);
        VendorLedgerEntry.SetFilter("Document Date", '%1..%2', StartDate, EndDate);
        if VendorLedgerEntry.FindSet() then
            repeat
                Total += VendorLedgerEntry."Purchase (LCY)";
            until VendorLedgerEntry.Next() = 0;
        exit(Total * (-1));
    end;

    local procedure GetDueAmount(VendorNo: Code[20]; Due: Boolean): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Total: Decimal;
    begin
        VendorLedgerEntry.SetRange("Vendor No.", VendorNo);
        VendorLedgerEntry.SetRange(Open, TRUE);
        IF Due then
            VendorLedgerEntry.SetFilter("Due Date", '< %1', Today)
        else
            VendorLedgerEntry.SetFilter("Due Date", '> %1', Today);
        VendorLedgerEntry.SetAutoCalcFields(VendorLedgerEntry."Remaining Amt. (LCY)");
        if VendorLedgerEntry.FindSet() then
            repeat
                Total += VendorLedgerEntry."Remaining Amt. (LCY)";
            until VendorLedgerEntry.Next() = 0;
        exit(Total * (-1));
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeCalculateVendorRate(var VendorQuality: Record "Vendor Quality_PKT"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterCalculateVendorRate(var VendorQuality: Record "Vendor Quality_PKT")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeManualReleasePurchaseDoc', '', false, false)]
    local procedure QualityCheckForReleasingPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    var
        VendorQuality: Record "Vendor Quality_PKT";
        PackSetup: Record "Pack Extension Setup";
        ErrNoMinimumRate: Label 'Vendor %1 has a rate of %2 and it''s under the required minimum value (%3)';
    begin
        PackSetup.Get();
        if VendorQuality.Get(PurchaseHeader."Buy-from Vendor No.") then begin
            if VendorQuality.Rate < PackSetup."Minimum Accepted Vendor Rate" then
                Error(ErrNoMinimumRate, PurchaseHeader."Buy-from Vendor No.",
            Format(VendorQuality.Rate), Format(PackSetup."Minimum Accepted Vendor Rate"));
        end;
    end;
}