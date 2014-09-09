Workflow Add-SRComment {
    param (
            [parameter(Mandatory=$true)]$SRID,
            [parameter(Mandatory=$true)][String]$Comment,
            [parameter(Mandatory=$true)][String]$EnteredBy
          )

    $SCSMServer = 'IPTLSS75'
    inlinescript {
        $ID = $USING:SRID
        $Comment = $USING:Comment
        $EnteredBy = $USING:EnteredBy

        $SRClass = get-scsmclass -Name System.Workitem.ServiceRequest$
        $SRObject = Get-SCSMObject -Class $srclass -Filter "DisplayName -like '$ID*'"

        $NewGUID = ([guid]::NewGuid()).ToString()
        $Projection = @{__CLASS = "System.WorkItem.ServiceRequest";
                        __SEED = $SRObject;
                        AnalystCommentLog = @{__CLASS = "System.WorkItem.TroubleTicket.AnalystCommentLog";
                                              __OBJECT = @{Id = $NewGUID;
                                                           DisplayName = $NewGUID;
                                                           Comment = $Comment;
                                                           EnteredBy  = $EnteredBy;
                                                           EnteredDate = (Get-Date).ToUniversalTime();
                                                           IsPrivate = $false
                                                          }
                                             }
                       }
        New-SCSMObjectProjection -Type "System.WorkItem.ServiceRequestProjection" -Projection $Projection
    } -psComputerName $SCSMServer
}


$ID = 'SR19821'

Add-SRComment -SRID $ID -Comment "PowerShell Workflow Comment 2" -EnteredBy "Stijn, Callebaut"

