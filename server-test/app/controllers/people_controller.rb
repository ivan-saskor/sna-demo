#include ApiHelper

class PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    
    respond_to do |format|
      if @person.save
        @person.gender = nil if @person.gender.empty?
        @person.gravatar_code = nil if @person.gravatar_code.empty?
        @person.save
        format.html { redirect_to(@person, :notice => 'Person was successfully created.') }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        @person.gender = nil if @person.gender.empty?
        @person.gravatar_code = nil if @person.gravatar_code.empty?
        @person.save
        format.html { redirect_to(@person, :notice => 'Person was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end

  def add_friend
    add_relation 'Friend', params[:id], params[:id2], params[:id]
  end

  def add_waiting_for_him
    add_relation 'WaitingForHim', params[:id], params[:id2], params[:id]
  end

  def add_waiting_for_me
    add_relation 'WaitingForHim', params[:id2], params[:id], params[:id]
  end

  def add_rejected
    add_relation 'Rejected', params[:id], params[:id2], params[:id], params[:rejected_on]
  end
  
  def add_relation relation_status, id, id2, id_to_show, rejected_on=nil
    @person_to_show = Person.find(id_to_show)
    @person = Person.find(id)
    @person_relation = PersonRelation.new

    @person_relation.from = @person
    @person_relation.to = Person.find(id2)
    @person_relation.relation_status_code = relation_status
    @person_relation.rejected_on = rejected_on

    respond_to do |format|
      if @person_relation.save
        format.html { redirect_to(@person_to_show, :notice => "#{relation_status} was successfully created.") }
      else
        format.html { redirect_to(@person_to_show, :notice => "#{relation_status} was NOT created.") }
      end
    end
  end
  
  def remove_relation
    @person = Person.find(params[:id])
    @relation = @person.find_relation(Person.find(params[:id2]))

    @relation.destroy

     respond_to do |format|
      format.html { redirect_to(@person) }
      format.xml  { head :ok }
    end
  end
end
