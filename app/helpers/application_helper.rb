module ApplicationHelper
  def get_title
    title = ['MD Trading', managable_content_for(:title)]
    title << content_for(:title) if content_for?(:title)
    title << @seo.title unless @seo.nil?
    title_join title
  end

  def title_join(values)
    values.compact.join(' : ')
  end

  def get_description
    description = [managable_content_for(:description)]
    description << content_for(:description) if content_for?(:description)
    description << @seo.description unless @seo.nil?
    description.join('; ')
  end

  def get_keywords
    keywords = [managable_content_for(:keywords)]
    keywords << content_for(:keywords) if content_for?(:keywords)
    keywords << @seo.keywords unless @seo.nil?
    keywords.join(', ')
  end

  def get_updated_at
    @seo && @seo.updated_at ? @seo.updated_at : managable_content_for(:updated_at)
  end

  def sitemap_category_entry(category, url_path)
    sitemap_entry send(url_path, :category_id => category.to_url_param)
  end

  def sitemap_article_entry(article, url_path)
    sitemap_entry send(url_path, :category_id => article.category.to_url_param, :article_id => article.to_url_param)
  end

  def sitemap_entry(url)
    content_tag(:url) do
      content_tag(:loc) do
        request.protocol + request.host_with_port + url
      end
    end
  end

end
