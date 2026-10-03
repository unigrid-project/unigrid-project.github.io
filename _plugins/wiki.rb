# frozen_string_literal: true

# Wiki checkouts carry no front matter, so Jekyll would copy their pages as static files.
# Publishing them as pages keeps each wiki the only copy of its documentation.
class WikiPages < Jekyll::Generator
  def generate(site)
    site.config.fetch("wikis", {}).each { |dir, section| publish(site, dir, section) }
  end

  private

  def publish(site, dir, section)
    files, site.static_files = site.static_files.partition { |file| wiki_page?(file, dir) }
    names = files.map { |file| File.basename(file.relative_path, ".md") }
    order = link_order(site, dir, names)
    names.each { |name| site.pages << page(site, dir, name, section, order) }
  end

  def wiki_page?(file, dir)
    file.extname == ".md" && File.dirname(file.relative_path.delete_prefix("/")) == dir
  end

  def page(site, dir, name, section, order)
    page = Jekyll::Page.new(site, site.source, dir, "#{name}.md")
    page.data.merge!("layout" => "default", "render_with_liquid" => false, "permalink" => "/#{dir}/#{name}")
    page.data.merge!(name == "Home" ? home_data(section) : child_data(page, name, section, order))
    page
  end

  def home_data(section)
    { "title" => section["title"], "nav_order" => section["nav_order"], "has_children" => true }
  end

  def child_data(page, name, section, order)
    { "title" => page.content[/^# (.+)$/, 1] || name.tr("-", " "), "parent" => section["title"],
      "nav_order" => order.index(name) + 1 }
  end

  # Navigation follows the order in which the sidebar, then the home page, then the other pages link to a page.
  def link_order(site, dir, names)
    text = (%w[_Sidebar Home] + names).uniq.filter_map do |name|
      path = site.in_source_dir(dir, "#{name}.md")
      File.read(path) if File.exist?(path)
    end.join("\n")
    names.sort_by { |name| [text.index(/\]\(#{Regexp.escape(name)}[)#]/) || Float::INFINITY, name] }
  end
end
