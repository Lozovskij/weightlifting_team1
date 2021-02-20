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
        public bool IsShown { get; set; }

        public bool IsModalVisible { get; set; }
        public string ErrorMsg { get; set; } = "Unhandled error";

        [Parameter]
        public Task<IEnumerable<TItem>> SearchDataTask { get; set; }

        [Parameter]
        public EventCallback OnDeleteClick { get; set; }

        public IEnumerable<TItem> GridData { get; set; }

        public string TableName { get; set; }

        int CurrentPage { get; set; } = 1;

        int PageSize { get; set; } = 11;
        
        protected override void OnInitialized()
        {
            TableName = typeof(TItem).Name;
        }

        protected override async Task OnInitializedAsync()
        {
            var watch = System.Diagnostics.Stopwatch.StartNew();
            // the code that you want to measure comes here
            GridData = await SearchDataTask;
            watch.Stop();
            var elapsedMs = watch.ElapsedMilliseconds;
            Console.WriteLine(elapsedMs);
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
            try
            {
                TItem item = (TItem)args.Item;
                await Task.Run(() => crudService.Update(item));
                await Task.Run(() => UpdateDataForView());
            }
            catch
            {
                IsModalVisible = true;
                ErrorMsg = "An error occurred during the update, please enter the data again";
            }
            
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
            await OnDeleteClick.InvokeAsync(new object());
            
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

            try
            {
                TItem item = (TItem)args.Item;
                await Task.Run(() => crudService.Create(item));
                await Task.Run(() => UpdateDataForView());
            }
            catch
            {
                IsModalVisible = true;
                ErrorMsg = "An error occurred during the add data operation, please enter the data again";
            }
           
        }

        async Task CancelHandler(GridCommandEventArgs args)
        {
            /*
            SampleData item = (SampleData)args.Item;

            // if necessary, perform actual data source operation here through your service
            */
        }

        public async void UpdateDataForView()
        {
            GridData = GetData<TItem>();
        }

        //it is slow
        public IEnumerable<T> GetData<T>() => dataRetrievalService.GetData<T>().OrderBy(item => typeof(T).GetProperty("Id").GetValue(item,null));
    }
}
