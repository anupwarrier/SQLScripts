--3 days of sproc performance
exec EXPEDBA.dbo.spSprocHistory     
      @database         = 'LodgingInventoryMaster09'      --DB to look at
      , @object         = 'TaxRateLst#13'     --Object to show
      , @cmd_no         = 1              --Filter by individual cmd          default = all
      , @end_date       = '2017-02-27 13:00:00'            --Last date to look at              default = getdate()
      , @show_header    = 1               --Show query plan etc, faster without for copy\paste operation
      , @grouped        = 1              --Group all results and show total for sproc
