module API
  class AttributesController < APIController
    include CreateInvitation

    def show
      check_access!('api:attributes:read')
      @object = Subject.find_by_shared_token(params[:shared_token])

      @provided_attributes =
        @object.provided_attributes
        .includes(permitted_attribute: [:available_attribute, :provider]).all

      @available_attributes = @provided_attributes.map do |a|
        a.permitted_attribute.available_attribute
      end

      @available_attributes.uniq!
    end

    def create
      check_access!('api:attributes:create')
      Subject.transaction do
        @provider = lookup_provider(params[:provider])
        @object = lookup_subject(@provider, params[:subject])
        params[:attributes].each do |attribute|
          update_attribute(@provider, @object,
                           attribute.permit(:name, :value, :_destroy))
        end

        render status: :no_content, nothing: true
      end
    end

    private

    def update_attribute(provider, subject, opts)
      return destroy_attribute(provider, subject, opts) if opts[:_destroy]
      create_attribute(provider, subject, opts)
    end

    def create_attribute(provider, subject, opts)
      permitted_attribute = lookup_permitted_attribute(provider, opts)

      audit_attrs = { audit_comment: 'Provided attribute via API call' }
      subject.provided_attributes.create_with(opts.merge(audit_attrs))
        .find_or_create_by!(permitted_attribute: permitted_attribute)
    end

    def destroy_attribute(provider, subject, opts)
      permitted_attribute = lookup_permitted_attribute(provider,
                                                       opts.except(:_destroy))

      attribute = subject.provided_attributes
                  .find_by(permitted_attribute: permitted_attribute)
      attribute.audit_comment = 'Revoked attribute via API call'
      attribute.destroy!
    end

    def lookup_permitted_attribute(provider, opts)
      permitted_attribute = provider.permitted_attributes
                            .joins(:available_attribute)
                            .find_by(available_attributes: opts)

      permitted_attribute ||
        fail(BadRequest, "#{provider.name} is not permitted to provide " \
                         "#{opts[:name]} with value #{opts[:value]}")
    end

    def lookup_provider(opts)
      if opts.nil? || opts[:identifier].nil?
        fail(BadRequest, 'The Provider is not properly identified')
      end

      provider = Provider.lookup(opts[:identifier])
      provider || fail(BadRequest, "The Provider #{opts[:identifier]} " \
                                   'was not found')

      check_access!("providers:#{provider.id}:attributes:create")
      provider
    end

    def lookup_subject(provider, identifier)
      if identifier[:shared_token]
        find_subject_by_shared_token(identifier[:shared_token])
      else
        find_or_create_subject(provider, identifier)
      end
    end

    def find_subject_by_shared_token(shared_token)
      Subject.find_by_shared_token(shared_token) ||
        fail(BadRequest, 'The Subject was not known to this system')
    end

    def find_or_create_subject(provider, identifier)
      name, mail = identifier.values_at(:name, :mail)

      if name.nil?
        fail(BadRequest, 'The Subject name was not provided, but is required')
      elsif mail.nil?
        fail(BadRequest, 'The Subject email address was not provided, ' \
                         'but is required')
      end

      Subject.find_by_mail(mail) || invite_subject(provider, name, mail)
    end

    def invite_subject(provider, name, mail)
      create_invitation(provider, name: name, mail: mail)
    end
  end
end
