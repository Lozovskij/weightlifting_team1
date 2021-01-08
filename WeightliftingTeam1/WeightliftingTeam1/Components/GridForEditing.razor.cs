using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Telerik.Blazor.Components;
using WeightliftingTeam1.Models;


namespace WeightliftingTeam1.Components
{
    public partial class GridForEditing<TItem>
    {
        [Parameter]
        public IEnumerable<TItem> GridData { get; set; }

        public string TableName { get; set; }

        int CurrentPage { get; set; } = 1;

        int PageSize { get; set; } = 11;
        
        protected override void OnInitialized()
        {
            TableName = typeof(TItem).Name;
        }

        async Task EditHandler(GridCommandEventArgs args)
        {
            // IGridModel item = (IGridModel)args.Item;
            // prevent opening for edit based on condition
            // if (item.ID < 3) ...
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
            TItem item = (TItem)args.Item;
            await Task.Run(() => crudService.Update(item));
            await Task.Run(() => UpdateDataForView());

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
            TItem item = (TItem)args.Item;
            await Task.Run(() => crudService.Delete(item));
            await Task.Run(() => UpdateDataForView());
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

            TItem item = (TItem)args.Item;
            await Task.Run(() => crudService.Create(item));
            await Task.Run(() => UpdateDataForView());
        }

        async Task CancelHandler(GridCommandEventArgs args)
        {
            /*
            SampleData item = (SampleData)args.Item;

            // if necessary, perform actual data source operation here through your service
            */
        }

        void UpdateDataForView()
        {
            GridData = dataRetrievalService.GetData<TItem>();
        }
    }
}
