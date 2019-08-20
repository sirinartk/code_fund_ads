import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    if (this.grid) return;
    const $grid = $(this.element).kendoGrid({
      sortable: true,
      reorderable: true,
      groupable: true,
      resizable: true,
      filterable: true,
      columnMenu: true,
      columns: this.columns,
      pageable: {
        alwaysVisible: true,
        pageSizes: [15, 25, 50, 100],
      },
    });
    this.grid = $grid.getKendoGrid();
    this.grid.dataSource.pageSize(this.pageSize);
    // if (this.columns) this.grid.columns = this.columns;
    this.grid.dataSource.page(1);
    if (this.grouping) this.grid.dataSource.group(this.grouping);
  }

  get pageSize() {
    return Number(this.element.dataset.pageSize || 10);
  }

  get grouping() {
    return this.element.dataset.grouping;
  }

  get columns() {
    if (this.element.dataset.columns) return JSON.parse(this.element.dataset.columns);
    else return [];
  }
}
