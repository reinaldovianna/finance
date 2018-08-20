class TableTaxesController < ApplicationController
  
 def index
    @table_taxes = TableTax.where({:table_scope => 'GLOBAL'}).paginate(page: params[:page], per_page: 50)

    render "index"
  end

  def new_table_tax
    @table_tax = TableTax.create({:status => 'new', :table_scope => 'GLOBAL'})

    respond_to do |format|
      format.html
      format.js
    end
  end

  def remove_unsaved_instance
    query_params = remove_table_tax_params.slice(:id).merge({:status => 'new', :table_scope => 'GLOBAL'})
    @table_tax = TableTax.find_by(query_params)

    respond_to do |format|
      if @table_tax && @table_tax.destroy
        format.json { render json: {}, :status => :ok }
      else
        format.json { render json: {}, :status => 400 }
      end
    end
  end

  def clone_table_tax
    @table_tax = TableTax.find(params[:id])
    table_tax_params = @table_tax.attributes.except('table_scope', 'id').merge({:status => 'new'})
    @table_tax_clone = TableTax.create(table_tax_params)
    
    @table_tax_clone.tax_rule_ids = @table_tax.tax_rule_ids

    render :json => { :form => render_to_string('/table_taxes/_form', :layout => false, :locals => { :table_tax => @table_tax_clone }) }
  end

  def show_table_tax
    @table_tax = TableTax.find(params[:id])

    render :json => { :form => render_to_string('/table_taxes/_form', :layout => false, :locals => { :table_tax => @table_tax }) }
  end

  def create
    @table_tax = TableTax.find(table_tax_params[:id])
    @table_tax.name = table_tax_params[:name]
    @table_tax.status = 'active'

    respond_to do |format|
      if valid_required_fields?(@table_tax) && @table_tax.save
        format.json { render json: {}, :status => :ok }
      else
        puts @table_tax.errors.join('') if valid_required_fields?(@table_tax)
        puts 'Erro no preenchimento dos campos' unless valid_required_fields?(@table_tax)
        format.json { render json: {}, :status => 400 }
      end
    end
  end
  
  def valid_required_fields? table_tax
    table_tax.name.present? && table_tax.row_ids.present?
  end

  def create_row
    @table_tax_row = TableTaxRow.where(row_params.except(:id)).first_or_initialize
    @table_tax = TableTax.find(table_params["id"])

    respond_to do |format|
      if @table_tax_row.save && !@table_tax.row_ids.include?(@table_tax_row.id)
        set_row_in_table(@table_tax_row, @table_tax)

        format.json { render :partial => "table_taxes/table_tax_row_line.html.erb", :locals => {row: @table_tax_row}, :format => [:html], :status => :ok, :layout => false }
      elsif @table_tax.row_ids.include?(@table_tax_row.id)
        format.json { render json: {:row_id => @table_tax_row.id.to_s}, :status => 409 }
      elsif @table_tax_row.errors.full_messages.present?
        format.json { render json: @table_tax_row.errors.full_messages.join("; "), :status => 422 }
      else
        format.json { render json: "Erro Interno. Entre com contato com nosso suporte.", :status => 400 }
      end
    end
  end

  def remove_row
    @table_tax = TableTax.find(table_params["id"])
    @table_tax_row = TableTaxRow.find(row_params["id"])

    respond_to do |format|
      if delete_row_in_table(@table_tax_row, @table_tax)
        format.json { render json: "Registro removido com sucesso", :status => :ok }
      else
        format.json { render json: @table_tax.errors.full_messages.join("; "), :status => 400 }
      end
    end
  end

  def create_rule
    @table_tax = TableTax.find(table_params["id"])

    row_ids_params = sort_rule_ids(rule_params['row_ids'])
    query_array = TaxRule.where(row_ids_array_query, row_ids_params)
    @table_tax_rule = query_array.where(rule_params.slice(:operator, :measurement, :value)).first_or_initialize    
    @table_tax_rule.row_ids = row_ids_params if @table_tax_rule.id.blank?

    respond_to do |format|
      if @table_tax_rule.save && !@table_tax.row_ids.include?(@table_tax_rule.id)
        set_rule_in_table(@table_tax_rule, @table_tax)

        format.json { render :partial => "table_taxes/table_tax_rule_line.html.erb", :locals => {rule: @table_tax_rule}, :format => [:html], :status => :ok, :layout => false }
      elsif @table_tax.row_ids.include?(@table_tax_rule.id)
        format.json { render json: {:row_id => @table_tax_rule.id.to_s}, :status => 409 }
      elsif @table_tax_rule.errors.full_messages.present?
        format.json { render json: @table_tax_rule.errors.full_messages.join("; "), :status => 422 }
      else
        format.json { render json: "Erro Interno. Entre com contato com nosso suporte.", :status => 400 }
      end
    end
  end

  def row_ids_array_query
    "row_ids = ARRAY[?]::integer[]"
  end

  def remove_rule
    @table_tax = TableTax.find(table_params["id"])
    @table_tax_rule = TaxRule.find(rule_params["id"])

    respond_to do |format|
      if delete_rule_in_table(@table_tax_rule, @table_tax)
        format.json { render json: "Registro removido com sucesso", :status => :ok }
      else
        format.json { render json: @table_tax.errors.full_messages.join("; "), :status => 400 }
      end
    end
  end

private
  def table_tax_params
    params.require(:table_tax).permit(:id, :name)
  end

  def remove_table_tax_params
    params.require(:table_tax).permit(:id)
  end

  def row_params
    params.require(:rows).permit(:id, :row_type, :row_name, :row_measurement, :row_value)
  end

  def rule_params
    params.require(:rules).permit([:id, {:row_ids => []}, :operator, :measurement, :value])
  end

  def table_params
    params.require(:table).permit(:id)
  end

  def set_row_in_table row, table
    table.row_ids << row.id
    table.save
  end

  def delete_row_in_table row, table
    table.row_ids = table.row_ids.reject{|r| r == row.id}
    table.save
  end

  def set_rule_in_table rule, table
    table.tax_rule_ids << rule.id
    table.tax_rule_ids = sort_rule_ids(table.tax_rule_ids)
    table.save
  end

  def sort_rule_ids tax_rules_ids
    tax_rules_ids.sort_by{ |id_rule| id_rule }    
  end

  def delete_rule_in_table rule, table
    table.tax_rule_ids = table.tax_rule_ids.reject{|r| r == rule.id}
    table.save
  end
end