using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Telerik.Blazor.Components;
using WeightliftingTeam1.Data;
using WeightliftingTeam1.ModelsForOutput;

namespace WeightliftingTeam1.Components
{
    public partial class MyTelerikGrid
    {
        [Parameter]
        public PanelType PanelType { get; set; }

        [Parameter]
        public List<IGridModel> DataForGrid { get; set; }

        async Task GetGridData()
        {
            //DataForGrid = await MyService.Read();
        }

        async Task EditHandler(GridCommandEventArgs args)
        {
            //IGridModel item = (IGridModel)args.Item;
        }

        async Task UpdateHandler(GridCommandEventArgs args)
        {
            /*
            IGridModel item = (IGridModel)args.Item;

            // perform actual data source operations here through your service
            await MyService.Update(item);

            // update the local view-model data with the service data
            await GetGridData();
            */
        }

        async Task DeleteHandler(GridCommandEventArgs args)
        {
            /*
            SampleData item = (SampleData)args.Item;

            // perform actual data source operation here through your service
            await MyService.Delete(item);

            // update the local view-model data with the service data
            await GetGridData();
            */

        }

        async Task CreateHandler(GridCommandEventArgs args)
        {
           /*
            SampleData item = (SampleData)args.Item;

            // perform actual data source operation here through your service
            await MyService.Create(item);

            // update the local view-model data with the service data
            await GetGridData();
           */
        }

        async Task CancelHandler(GridCommandEventArgs args)
        {
            /*
            SampleData item = (SampleData)args.Item;

            // if necessary, perform actual data source operation here through your service
            */
        }

    }
}
