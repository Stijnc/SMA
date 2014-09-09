Workflow Add-SCSMIRAnalystComment {
    param (
            [parameter(Mandatory=$true)]$IRID,
            [parameter(Mandatory=$true)][String]$Comment,
            [parameter(Mandatory=$true)][String]$EnteredBy
          )

    $SCSMServer = 'IPTLSS75'
    inlinescript {
        $ID = $USING:SRID
        $Comment = $USING:Comment
        $EnteredBy = $USING:EnteredBy

        $IRClass = get-scsmclass -Name System.Workitem.Incident$
        $IRObject = Get-SCSMObject -Class $irclass -Filter "DisplayName -like '$ID*'"

        $NewGUID = ([guid]::NewGuid()).ToString()
        $Projection = @{__CLASS = "System.WorkItem.Incident";
                        __SEED = $IRObject;
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


$ID = 'IR13368'

Add-SCSMIRAnalystComment -IRID $ID -Comment "PowerShell Workflow Comment 2" -EnteredBy "Stijn, Callebaut"

