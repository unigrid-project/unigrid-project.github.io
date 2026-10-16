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
    pages = names.to_h { |name| [name, page(site, dir, name, section)] }
    nest(pages, sidebar_parents(site, dir), link_order(site, dir, names))
    site.pages.concat(pages.values)
  end

  def wiki_page?(file, dir)
    file.extname == ".md" && File.dirname(file.relative_path.delete_prefix("/")) == dir
  end

  def page(site, dir, name, section)
    page = Jekyll::Page.new(site, site.source, dir, "#{name}.md")
    title = name == "Home" ? section["title"] : page.content[/^# (.+)$/, 1] || name.tr("-", " ")
    page.data.merge!("layout" => "default", "render_with_liquid" => false, "permalink" => "/#{dir}/#{name}",
                     "title" => title)
    page.data.merge!("nav_order" => section["nav_order"], "has_children" => true) if name == "Home"
    page
  end

  # A page sits under the page whose sidebar entry encloses its own, or else under the home page. The
  # grandparent tells apart parents that share a title with a page elsewhere on the site.
  def nest(pages, parents, order)
    parent = ->(name) { pages.key?(parents[name]) ? parents[name] : "Home" }
    title = ->(name) { pages[name].data["title"] }
    pages.except("Home").each do |name, page|
      page.data.merge!("parent" => title.(parent.(name)), "nav_order" => order.index(name) + 1)
      page.data["grand_parent"] = title.(parent.(parent.(name))) unless parent.(name) == "Home"
    end
  end

  def sidebar_parents(site, dir)
    path = site.in_source_dir(dir, "_Sidebar.md")
    return {} unless File.exist?(path)

    enclosing = []
    File.readlines(path).each_with_object({}) do |line, parents|
      next unless (item = line.match(/^(\s*)[-*+] \[[^\]]*\]\(([^)#]+)/))

      enclosing.pop while enclosing.any? && enclosing.last[:indent] >= item[1].length
      parents[item[2]] = enclosing.last&.fetch(:name)
      enclosing << { indent: item[1].length, name: item[2] }
    end
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
