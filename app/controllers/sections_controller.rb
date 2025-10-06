class SectionsController < ApplicationController
  before_action :set_section, only: [ :show, :edit, :update, :destroy ]
  before_action :set_parent_section, only: [ :new, :create ]

  def index
    @sections = Section.roots
  end

  def show
    @children = @section.children
    @articles = @section.articles
  end

  def new
    @section = Section.new(parent: @parent_section)
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      redirect_path = @section.parent ? section_path(@section.parent) : sections_path
      redirect_to redirect_path, notice: "Раздел создан"
    else
      flash.now[:alert] = "Не удалось создать раздел: #{@section.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @parent_options = Section.where.not(id: @section.id).map { |s| [ s.full_path, s.id ] }
  end

  def update
    if @section.update(section_params)
      redirect_path = @section.parent ? section_path(@section.parent) : sections_path
      redirect_to redirect_path, notice: "Раздел обновлен"
    else
      @parent_options = Section.where.not(id: @section.id).map { |s| [ s.full_path, s.id ] }
      flash.now[:alert] = "Не удалось обновить раздел: #{@section.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    parent_section = @section.parent
    @section.destroy

    redirect_path = parent_section ? section_path(parent_section) : sections_path
    redirect_to redirect_path, notice: "Раздел удален"
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def set_parent_section
    @parent_section = Section.find_by(id: params[:parent_id])
  end

  def section_params
    params[:section][:parent_id] = nil if params[:section][:parent_id].blank?
    params.require(:section).permit(:title, :description, :parent_id)
  end
end
