class PersonRelationsController < ApplicationController
  # GET /person_relations
  # GET /person_relations.xml
  def index
    @person_relations = PersonRelation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @person_relations }
    end
  end

  # GET /person_relations/1
  # GET /person_relations/1.xml
  def show
    @person_relation = PersonRelation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person_relation }
    end
  end

  # GET /person_relations/new
  # GET /person_relations/new.xml
  def new
    @person_relation = PersonRelation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person_relation }
    end
  end

  # GET /person_relations/1/edit
  def edit
    @person_relation = PersonRelation.find(params[:id])
  end

  # POST /person_relations
  # POST /person_relations.xml
  def create
    @person_relation = PersonRelation.new(params[:person_relation])

    respond_to do |format|
      if @person_relation.save
        format.html { redirect_to(@person_relation, :notice => 'Person relation was successfully created.') }
        format.xml  { render :xml => @person_relation, :status => :created, :location => @person_relation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person_relation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /person_relations/1
  # PUT /person_relations/1.xml
  def update
    @person_relation = PersonRelation.find(params[:id])

    respond_to do |format|
      if @person_relation.update_attributes(params[:person_relation])
        format.html { redirect_to(@person_relation, :notice => 'Person relation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person_relation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /person_relations/1
  # DELETE /person_relations/1.xml
  def destroy
    @person_relation = PersonRelation.find(params[:id])
    @person_relation.destroy

    respond_to do |format|
      format.html { redirect_to(person_relations_url) }
      format.xml  { head :ok }
    end
  end
end
